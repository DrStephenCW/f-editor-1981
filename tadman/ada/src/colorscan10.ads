with text_io; use text_io;
package colorscan10 is
    type color is 
	(black, blue, red, green, yellow, magenta, 
	 cyan, white);
    type video_attribute is 
	(primary, bold, underscore, blink, 
	 reverse_video);
    type erase_option is 
	(to_end, from_beginning, entirely);
    procedure erase_display(op: in erase_option);

    procedure erase_line(op: in erase_option);

    procedure set_tab;

    procedure clear_tab;

    procedure clear_all_tabs;

    procedure invoke_cursor_position_report;

    procedure cursor_left(n: in integer);

    procedure cursor_right(n: in integer);

    procedure cursor_up(n: in integer);

    procedure cursor_down(n: in integer);

    procedure cursor_home;

    procedure set_cursor(r, c: in integer);

    procedure line_feed_mode_lf_only;

    procedure line_feed_mode_cr_lf;

    procedure index;

    procedure reverse_index;

    procedure next_line;

    procedure save_cursor_attributes;

    procedure restore_cursor_attributes;

    procedure double_high_top_half;

    procedure double_high_bottom_half;

    procedure double_wide;

    procedure single_width;

    procedure all_leds_off;

    procedure led1_on;

    procedure led2_on;

    procedure led3_on;

    procedure led4_on;

    procedure auto_repeat_on;

    procedure auto_repeat_off;

    procedure column_132;

    procedure column_80;

    procedure cursor_application_mode_on;

    procedure cursor_application_mode_off;

    procedure key_pad_application_mode_on;

    procedure key_pad_numeric_mode_on;

    procedure origin_relative;

    procedure origin_absolute;

    procedure screen_reverse;

    procedure screen_normal;

    procedure smooth_scrolling;

    procedure jump_scrolling;

    procedure wraparound_on;

    procedure wraparound_off;

    procedure use_ascii_character_set;

    procedure use_special_graphics;

    procedure set_color(
	    foreground, background: in color);

    procedure video_attributes(
	    attr: in video_attribute);

    procedure scrolling_region(
	    top, bottom: in integer);

end colorscan10;
