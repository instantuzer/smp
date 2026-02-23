#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s {vol-up|vol-down|vol-toggle|bright-up|bright-down}\n", argv[0]);
        return 1;
    }

    char *cmd = argv[1];

    // --- Volume controls ---
    if (strcmp(cmd, "vol-up") == 0) {
        system("pactl set-sink-volume @DEFAULT_SINK@ +5%");
    } else if (strcmp(cmd, "vol-down") == 0) {
        system("pactl set-sink-volume @DEFAULT_SINK@ -5%");
    } else if (strcmp(cmd, "vol-toggle") == 0) {
        system("pactl set-sink-mute @DEFAULT_SINK@ toggle");
    }
    // --- Brightness controls ---
    else if (strcmp(cmd, "bright-up") == 0) {
        system("brightnessctl set +8%");
    } else if (strcmp(cmd, "bright-down") == 0) {
        system("brightnessctl set 8%-");
    } else {
        printf("Usage: %s {vol-up|vol-down|vol-toggle|bright-up|bright-down}\n", argv[0]);
        return 1;
    }

    // --- Notifications ---
    if (strncmp(cmd, "vol-", 4) == 0) {
        FILE *fp;
        char vol[16], muted[8];

        // Get volume
        fp = popen("pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1", "r");
        if (fp) {
            fgets(vol, sizeof(vol), fp);
            pclose(fp);
        }

        // Get mute status
        fp = popen("pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'", "r");
        if (fp) {
            fgets(muted, sizeof(muted), fp);
            pclose(fp);
        }

        if (strncmp(muted, "yes", 3) == 0) {
            char notify_cmd[128];
            snprintf(notify_cmd, sizeof(notify_cmd),
                     "dunstify -u low -r 6666 -t 1000 \"Volume: Muted %s\"", vol);
            system(notify_cmd);
        } else {
            char notify_cmd[128];
            snprintf(notify_cmd, sizeof(notify_cmd),
                     "dunstify -u low -r 6666 -t 1000 \"Volume: %s\"", vol);
            system(notify_cmd);
        }
    }

    if (strncmp(cmd, "bright-", 7) == 0) {
        FILE *fp;
        int bri, max;
        // Get current brightness
        fp = popen("brightnessctl g", "r");
        if (fp) {
            fscanf(fp, "%d", &bri);
            pclose(fp);
        }
        // Get max brightness
        fp = popen("brightnessctl m", "r");
        if (fp) {
            fscanf(fp, "%d", &max);
            pclose(fp);
        }

        int percent = (bri * 100) / max;

        char notify_cmd[128];
        snprintf(notify_cmd, sizeof(notify_cmd),
                 "dunstify -u low -r 5555 \"Brightness: %d%%\"", percent);
        system(notify_cmd);
    }

    return 0;
}
