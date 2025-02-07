{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  hyprctl = "${config.programs.hyprland.package}/bin/hyprctl";
  onlyoffice-desktopeditors = "${pkgs.onlyoffice-bin}/bin/onlyoffice-desktopeditors --system-title-bar --xdg-desktop-portal";

  cfg = config.custom.programs.onlyoffice;
in {
  options.custom.programs.onlyoffice.enable = mkOption {default = false;};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [onlyoffice-bin];

    home-manager.users.${config.custom.username} = {
      home.file.".local/share/applications/onlyoffice-desktopeditors.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Name=ONLYOFFICE Desktop Editors
        GenericName=Document Editor
        Comment=Edit office documents
        Type=Application
        Exec=${hyprctl} dispatch exec "[group override set; tile] ${onlyoffice-desktopeditors} %U"
        Terminal=false
        Icon=onlyoffice-desktopeditors
        Keywords=Text;Document;OpenDocument Text;Microsoft Word;Microsoft Works;odt;doc;docx;rtf;
        Categories=Office;WordProcessor;Spreadsheet;Presentation;
        MimeType=application/vnd.oasis.opendocument.text;application/vnd.oasis.opendocument.text-template;application/vnd.oasis.opendocument.text-web;application/vnd.oasis.opendocument.text-master;application/vnd.sun.xml.writer;application/vnd.sun.xml.writer.template;application/vnd.sun.xml.writer.global;application/msword;application/vnd.ms-word;application/x-doc;application/rtf;text/rtf;application/vnd.wordperfect;application/wordperfect;application/vnd.openxmlformats-officedocument.wordprocessingml.document;application/vnd.ms-word.document.macroenabled.12;application/vnd.openxmlformats-officedocument.wordprocessingml.template;application/vnd.ms-word.template.macroenabled.12;application/vnd.oasis.opendocument.spreadsheet;application/vnd.oasis.opendocument.spreadsheet-template;application/vnd.sun.xml.calc;application/vnd.sun.xml.calc.template;application/msexcel;application/vnd.ms-excel;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;application/vnd.ms-excel.sheet.macroenabled.12;application/vnd.openxmlformats-officedocument.spreadsheetml.template;application/vnd.ms-excel.template.macroenabled.12;application/vnd.ms-excel.sheet.binary.macroenabled.12;text/csv;text/spreadsheet;application/csv;application/excel;application/x-excel;application/x-msexcel;application/x-ms-excel;text/comma-separated-values;text/tab-separated-values;text/x-comma-separated-values;text/x-csv;application/vnd.oasis.opendocument.presentation;application/vnd.oasis.opendocument.presentation-template;application/vnd.sun.xml.impress;application/vnd.sun.xml.impress.template;application/mspowerpoint;application/vnd.ms-powerpoint;application/vnd.openxmlformats-officedocument.presentationml.presentation;application/vnd.ms-powerpoint.presentation.macroenabled.12;application/vnd.openxmlformats-officedocument.presentationml.template;application/vnd.ms-powerpoint.template.macroenabled.12;application/vnd.openxmlformats-officedocument.presentationml.slide;application/vnd.openxmlformats-officedocument.presentationml.slideshow;application/vnd.ms-powerpoint.slideshow.macroEnabled.12;x-scheme-handler/oo-office;text/docxf;text/oform;
        Actions=NewDocument;NewSpreadsheet;NewPresentation;NewForm;

        [Desktop Action NewDocument]
        Name=New document
        Exec=${hyprctl} dispatch exec "[group override set; tile] ${onlyoffice-desktopeditors} --new:word"

        [Desktop Action NewSpreadsheet]
        Name=New spreadsheet
        Exec=${hyprctl} dispatch exec "[group override set; tile] ${onlyoffice-desktopeditors} --new:cell"

        [Desktop Action NewPresentation]
        Name=New presentation
        Exec=${hyprctl} dispatch exec "[group override set; tile] ${onlyoffice-desktopeditors} --new:slide"

        [Desktop Action NewForm]
        Name=New PDF form
        Exec=${hyprctl} dispatch exec "[group override set; tile] ${onlyoffice-desktopeditors} --new:form"
      '';
    };
  };
}
