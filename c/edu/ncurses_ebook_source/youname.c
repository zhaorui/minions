#include <ncurses.h>

int main()
{
	char first[24];
	char last[32];

	initscr();
	addstr("What is your first name? ");
	refresh();
	getnstr(first,23);

	addstr("What is your last name? ");
	refresh();
	getnstr(last,31);

	printw("Pleased to meet you, %s %s!",first,last);
	refresh();
	getch();

	endwin();
	return(0);
}

