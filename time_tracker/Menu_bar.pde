import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

public class Menu_bar {
  JFrame frame;

  public Menu_bar(PApplet app, String name, int width, int height) {
    System.setProperty("apple.laf.useScreenMenuBar", "true");
    frame = (JFrame) ((processing.awt.PSurfaceAWT.SmoothCanvas)app.getSurface().getNative()).getFrame();
    frame.setTitle(name);

    // Creates a menubar for a JFrame
    JMenuBar menu_bar = new JMenuBar();
    // Add the menubar to the frame
    frame.setJMenuBar(menu_bar);
    // Define and add two drop down menu to the menubar
    JMenu file_menu = new JMenu("File");
    JMenu text_menu = new JMenu("text");
    JMenu shape_menu = new JMenu("shape");
    JMenu image_menu = new JMenu("image");
    JMenu preferences_menu = new JMenu("Preferences");

    menu_bar.add(file_menu);
    menu_bar.add(text_menu);
    menu_bar.add(shape_menu);
    menu_bar.add(image_menu);
    menu_bar.add(preferences_menu);

    // Create and add simple menu item to one of the drop down menu
    JMenuItem new_file = new JMenuItem("Import file");
    JMenuItem action_load = new JMenuItem("Load Date");
    JMenuItem action_exit = new JMenuItem("Exit");

    file_menu.add(new_file);
    file_menu.add(action_load);
    file_menu.addSeparator();
    file_menu.add(action_exit);

    JMenuItem change_activites = new JMenuItem("Change Activites");
    JMenuItem change_colors = new JMenuItem("Change Colors");

    preferences_menu.add(change_activites);
    preferences_menu.add(change_colors);


    // Add a listener to the New menu item. actionPerformed() method will
    // invoked, if user triggred this menu item
    action_exit.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent arg0) {
        saveNewFile();
        System.exit(0);
        System.out.println("Exiting");
      }
    }
    );

    action_load.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent arg0) {
        loadPreviousFile();
        System.out.println("Loading");
      }
    }
    );

    




      change_activites.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent arg0) {
        System.out.println("Change the Activities Palette");
        state_changeActivities = true;
        state_changeColors = false; 
        state_colorGrid = false;
      }
    }
    );

    change_colors.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent arg0) {
        System.out.println("Change the Color Palette");
        state_changeActivities = false;
        state_changeColors = true; 
        state_colorGrid = false;
      }
    }
    );
    frame.setVisible(true);
  }
}