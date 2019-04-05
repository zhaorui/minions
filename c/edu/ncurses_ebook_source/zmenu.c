#include <stdio.h>
#include <ncurses.h>

const char* items[] = {
    "Kongpao Chicken",
    "Potato Chips",
    "Salami Pizza"
};

int main(int argc, const char**argv) {

	WINDOW* menu;
	menu = newwin(sizeof(items)/sizeof(items[0]), 100, 0, 0);
	for(size_t i = 0; i < sizeof(items)/sizeof(items[0]); i++)
	{
		waddstr(menu, items[i]);
	}
	
	nodelay(menu, false);
	wgetch(menu);
    // keypad(newwin,TRUE);
	// do
	// {
	// 	ch = getch();
	// 	char buffer[BUFSIZ];
	// 	snprintf(buffer, sizeof(buffer), "getch: %d\n", ch);
	// 	addstr(buffer);
	// 	switch(ch)
	// 	{
	// 		case KEY_DOWN:
	// 			addstr("Down\n");
	// 			break;
	// 		case KEY_UP:
	// 			addstr("Up\n");
	// 			break;
	// 		case KEY_LEFT:
	// 			addstr("Left\n");
	// 			break;
	// 		case KEY_RIGHT:
	// 			addstr("Right\n");
	// 		default:
	// 			break;
	// 	}
	// 	refresh();
	// } while(ch != '\n');
    return 0;
}