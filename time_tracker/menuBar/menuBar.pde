Menu_bar mp;

void setup() {
  size(500,500);
  buildMenuBar();
}

void draw() {
}

void buildMenuBar() {
  mp = new Menu_bar(this, "Media", 100, 100);
}