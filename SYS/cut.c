/* UNIX-like cut filter for MS-DOS
 *
 * Cut Version 1.0, 16-Sept-92 by Jason Mathews
 *
 * Modification history:
 *
 *   V1.0 16-Sept-92	Original version (clone of System V cut command)
 *			Compiled and tested with Borland C++ V2.0 compiler.
 ****************************************************************************
 *
 *  Removes selected fields from each line of a file
 *
 *      usage: cut [-s] [-d<char>] {-c<list> | -f<list>} file ...
 *
 * options:
 *	-c<list> = By character position.  list is a comma-separated list of
 *	integer field numbers with an optional '-' to indicate ranges:
 *
 *	  1,4,7 characters 1,4, and 7
 *	  1-3,8 characters 1 through 3, and 8
 *	  -5,10 characters (1) through 5, and 10
 *	  3- characters 3 through (last)
 *
 *	-f<list> = By field position.  Instead of character positions, list
 *	specifies fields that are separated by a deliniter (normally a TAB):
 *
 *	  1,4,7 fields 1,4, and 7
 *
 *	Lines with no field delimiters are normally passed through intact
 *	(to allow for subheadings).
 *
 *	-d<c> = Set field delimiter to c.  The default is TAB.
 *
 *	-s    = Supress lines with no delimiter characters
 *		or blank lines when using a column list.
 *
 *
 ****************************************************************************/

#include <stdio.h>
#include <io.h>
#include <fcntl.h>

#define LF 0xa
#define CR 0xd
#define MAX_FIELD_SIZE 1023

typedef unsigned char bool;

enum { UNSELECTED=0, COLUMN, FIELD } ModeType;

bool field_list[MAX_FIELD_SIZE]; /* list of selected fields */
bool SupressFlag = 0;		 /* supress lines without delimiter symbol */
enum ModeType mode = UNSELECTED; /* scan mode: column vs. field */
unsigned char delimiter = '\t';	 /* delimiter symbol for field separation */

void Usage(), CheckLine();
int Set_list();

void main (int argc, char **argv)
{
	int c;
	char *filename = 0;
	int error = 0;
	char buffer[MAX_FIELD_SIZE+1];

	/* initialize field list to all zeros */
	memset(field_list, 0, MAX_FIELD_SIZE);

	/* skip over 0 argument and increment through arg-list */
	while (*(++argv) && (**argv == '-' || **argv=='/') && error == 0)
	{
		switch (*(++*argv)) {
		case 'd':
			delimiter = *(*argv+1);
			if (delimiter=='\\' && *(*argv+2)=='t')
			{
				delimiter = '\t';
			}
			else if (delimiter==0) delimiter=' ';
			break;
		case 'f':
			if (mode != COLUMN)
                        {
				mode = FIELD;
                                error = Set_list(*argv+1);
                        }
			else error = 1;
			break;
		case 'c':
                        if (mode != FIELD)
                        {
				mode = COLUMN;
                                error = Set_list(*argv+1);
                        }
			else error = 1;
			break;
		case 's':
			SupressFlag = 1;
			break;
		default:
			Usage();
		}
	}

        if (mode == UNSELECTED) error = 1;

        if (error != 0)
	{
                fprintf(stderr, "cut: ERROR: ");
		switch (error) {
		case 1:
                        fprintf(stderr, "bad list for c/f option\n\n");
			break;
		case 2:
			fprintf(stderr, "line cannot have more than %d characters or fields\n\n", MAX_FIELD_SIZE);
		}
		Usage();
	}

	if (*argv == NULL)	/* check for no file list */
	{
		setmode(0, O_BINARY); /* read data from stdin */
	}

	setmode(1, O_BINARY);	/* set output to binary mode */

	do
	{
		if (*argv != NULL)
		{
			filename = *argv++;
			/* redirect stdin to file stream */
			if (freopen (filename, "rb", stdin)==0)
			{
                                fprintf(stderr, "cut: WARNING: cannot open ");
                                perror(filename);
				continue; /* go to next file if available */
			}
		}

		while (fgets(buffer, MAX_FIELD_SIZE, stdin))
		  CheckLine(buffer);

	} while (*argv);  /* continue while more files */

	exit(0);
} /* end main */


/*
 *  Usage - Show program syntax
 */
void Usage()
{
	fprintf(stderr, "UNIX cut (C) 1992 Jason Mathews\n");
	fprintf(stderr, "cut [-s] [-d<char>] {-c<list> | -f<list>} file ...\n");
	exit(0);
}


/*
 *  Set_list - Parse field argument list and set selected fields
 */
int Set_list (char *list)
{
	bool setFieldFlag = 0;	/* flag to indicate if any fields were set */
	bool contFlag = 0;	/* flag to continue setting fields for a range (i-j) */
	unsigned prevField = 0;	/* previous field selected */
	unsigned field;		/* field position */

	while (*list)
	{
		switch (*list) {
		 case '-':
                        if (contFlag) return(1);
                        contFlag = 1;   /* turn on continue flag */
			list++;
			break;
		 case ',':
                        contFlag = 0;
			list++;
			break;
		 default:
			field = 0;
			while (*list >= '0' && *list <= '9')
			{
				field *= 10;
				field += *list - '0';
				++list;
			}
			if (field == 0) return(1);
			else if (field > MAX_FIELD_SIZE) return(2);
			--field;  /* decrement field # for array index */
                        if (!contFlag) prevField = field;
                        else contFlag = 0;
			while (prevField <= field)
			{
				field_list[prevField++] = 1;
			}
                        setFieldFlag = 1; /* set field selected flag */
		} /* end switch */
	} /* end while */

        if (contFlag)
	{
		while (prevField <= MAX_FIELD_SIZE)
		{
			field_list[prevField++] = 1;
		}
	}

        if (setFieldFlag == 0) return 1;  /* error - nothing selected */
	else return 0;			  /* okay */
} /* end Set_list */


/*
 *  CheckLine - check and parse current input line
 */
void CheckLine (char *buffer)
{
	unsigned field = 0;
	if (mode == FIELD) /* Field-wise checking */
	{
		char *buf_p = buffer;
                bool no_delim_Flag = 0; /* flag to print lines w/o delimiter */
		bool show_delim_Flag = 0; /* flag to print delimiter symbol */

                /* check if any delimiter symbols are in the line */
		while (*buf_p != 0 && *buf_p != delimiter) buf_p++;
		if (*buf_p == 0) /* If EOL reached then no delim */
		{
			if (SupressFlag)
				return;		/* supress printing of line */
			else
				no_delim_Flag = 1; /* show line */
		}

		while (*buffer != 0)
		{
			if (*buffer == delimiter)
			{
                                if (field_list[field]) show_delim_Flag = 1;
				field++;
                	}
                        else if (field_list[field] || no_delim_Flag)
                        {
				if (show_delim_Flag)
                                {
					putchar(delimiter);
                                        show_delim_Flag = 0;
				}
				if (*buffer!=CR && *buffer!=LF)
				putchar(*buffer);
			}
			buffer++;
		} /* end while */
	}
	else  /* Column-wise character checking */
	{
                bool printedFieldFlag = 0;
		while (*buffer != 0)
                {
			if (field_list[field++] && *buffer!=CR && *buffer!=LF)
			{
				/* set flag to indicate something was printed */
                                printedFieldFlag = 1;
				putchar(*buffer);
			}
			buffer++;
		} /* end while */

                /* ignore blank lines if suppression was picked */
                if (SupressFlag && !printedFieldFlag) return;
	}
	putchar(CR);putchar(LF);
} /* end CheckLine */
