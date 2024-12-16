program slide_NEO;
{
Auteur: Patrick Pr‚martin.
Date: 21/02/1992. (1.0)
      Refaite le 25/06/1992.
Langage: Turbo Pascal 6.0
But: Affichage des images au format NEO sur un ‚cran VGA. Le seul paramŠtre de
     ce programme est le chemin d'accŠs aux images, il parcoure l'arborescence
     et les affiche toutes.
     Ne fonctionne que sur ‚cran VGA en 256 couleurs.
}
uses
    olf_software,
    crt,
    dos,
    u_fdtree,
    u_m_util,
    u_parametre,
    u_code_clavier,
    u_picture;

const
     num_vers : string [3] = '1.0';
     dat_vers : string [10] = '06/25/1992';

type
    o_prg = object (o_fdtree)
                   constructor init;
                   function treat_file (f : searchrec) : boolean; virtual;
                   function stop_run : boolean; virtual;
    end;


var
   pic : p_NEO;
   prog : o_prg;
   old_dir : string;

procedure lit_image (nom : string); forward;

constructor o_prg.init;
begin
     o_fdtree.init;
     set_file_mask ('*.NEO');
end; { o_prg.init }

function o_prg.treat_file (f : searchrec) : boolean;
begin
     coul_min := 48 - coul_min;
     lit_image (f.name);
     palette_adapte (pic^.palette);
     affiche_image (pic^.image);
     dispose (pic);
     delay (5000); { Attente de 5 secondes. }
     treat_file := true;
end; { o_prg.treat_file }

function o_prg.stop_run : boolean;
var
   fin : boolean;
begin
     if (keypressed)
     then
         case readkey of
              ' ' : fin := (readkey = touche_escape);
              touche_escape : fin := true;
         end;
     {endif}
     stop_run := fin;
end; { o_prg.stop_run }

procedure lit_image (nom : string);
var
   fich : file of t_NEO;
begin
     new (pic);
     if (pic = nil)
     then
         begin
              alert ('Not enough memory to run...', al_error);
              halt (1);
         end;
     {endif}
     assign (fich, nom);
     reset (fich);
     read (fich, pic^);
     close (fich);
end; { lit_image }

begin
     init_licence ('slide');
     init_olf_message (mess_freeware);
     init_ligne_olf_software ('Slide NEO '+num_vers, '(c) Patrick Pr‚martin '+dat_vers);
     if (param_del ('/?') or param_del ('/H'))
     then
         begin
              writeln;
              writeln ('Syntax:');
              writeln ('     SLIDENEO [/?|/H] [PATH_NAME]');
              writeln;
              writeln ('Use this program to see all NEO pictures in PATH_NAME and its');
              writeln ('sub-directories. VGA GRAPHICS CARD ONLY...');
              writeln;
         end
     else
         begin
              coul_min := 16;
              getdir (0, old_dir);
              prog.init;
              if (paramcount = 1)
              then
                  prog.set_start_directory (paramstr (1))
              else
                  prog.set_start_directory (old_dir);
              {endif}
              prog.run;
              prog.done;
              chdir (old_dir);
         end;
     {endif}
end.
