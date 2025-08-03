package mashumelo;

//imports
import net.dv8tion.jda.api.entities.Guild;
import net.dv8tion.jda.api.entities.User;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import net.dv8tion.jda.api.entities.channel.middleman.AudioChannel;
import net.dv8tion.jda.api.events.guild.member.GuildMemberJoinEvent;
import net.dv8tion.jda.api.events.guild.member.GuildMemberRemoveEvent;
import net.dv8tion.jda.api.events.guild.voice.GuildVoiceUpdateEvent;
import net.dv8tion.jda.api.events.user.update.UserUpdateAvatarEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import net.dv8tion.jda.api.EmbedBuilder;

import java.awt.*;
import java.time.Instant;

import org.jetbrains.annotations.NotNull;

public class EventListener extends ListenerAdapter {

    @Override
    public void onGuildVoiceUpdate(@NotNull GuildVoiceUpdateEvent event) {
        // Get the text channel where you want to send the update
        TextChannel channel = event.getGuild().getTextChannelById("1122394088189206552");
        User user = event.getEntity().getUser();
        AudioChannel oldChannel = event.getChannelLeft();
        AudioChannel newChannel = event.getChannelJoined();

        if (oldChannel != null) {
            // User left a specific voice channel
            String message = user.getAsMention() + " left " + oldChannel.getAsMention();
            channel.sendMessage(message).complete();
            System.out.println(message);
        }

        if (newChannel != null) {
            // User joined a specific voice channel
            String message = user.getAsMention() + " joined " + newChannel.getAsMention();
            channel.sendMessage(message).complete();
            System.out.println(message);
        }
    }

    @Override
    public void onGuildMemberJoin(GuildMemberJoinEvent event) {
        User user = event.getUser();
        Guild guild = event.getGuild();

        // Perform actions when a user joins the server
        System.out.println(user.getName() + " has joined " + guild.getName() + "!");

        //Get the text channel where you want to send the update
        TextChannel channel = event.getJDA().getTextChannelById("1122394088189206555");

        if (channel != null) {
            // User joined the server
            String message = user.getAsMention() + " has joined the server!";
            channel.sendMessage(message).complete();
            System.out.println(message);
        }

    }

    @Override
    public void onGuildMemberRemove(GuildMemberRemoveEvent event) {
        User user = event.getUser();
        Guild guild = event.getGuild();

        // Perform actions when a user leaves the server
        System.out.println(user.getName() + " has left " + guild.getName() + "!");

        //Get the text channel where you want to send the update
        TextChannel channel = event.getJDA().getTextChannelById("1122394088189206555");

        if (channel != null) {
            // User left the server
            String message = user.getAsMention() + " has left the server!";
            channel.sendMessage(message).complete();
            System.out.println(message);
        }
    }

    @Override
    public void onUserUpdateAvatar(@NotNull UserUpdateAvatarEvent event) {
        System.out.println("Avatar update event received for user: " + event.getUser().getName());
        // Get the text channel where you want to send the update
        TextChannel channel = event.getJDA().getTextChannelById("1239300388952346745");

        if (channel != null) {
            String newAvatarUrl = event.getNewAvatarUrl();

            // Build an embed with updated avatar
            EmbedBuilder embedBuilder = new EmbedBuilder();
            embedBuilder.setColor(Color.PINK); // Set the color of the embed
            embedBuilder.setTitle(event.getUser().getName() + " updated their user avatar!");
            embedBuilder.setImage(newAvatarUrl);

            // Add a timestamp
            embedBuilder.setTimestamp(Instant.now());

            // Send the embed
            channel.sendMessageEmbeds(embedBuilder.build()).queue();
        }
    }
}
