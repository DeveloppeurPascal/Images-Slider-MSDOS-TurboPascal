program slide_ppp;
{
Auteur: Patrick Pr‚martin.
Date: 21/02/1992. (1.0)
      Refaite le 25/06/1992.
Langage: Turbo Pascal 6.0
But: Affichage des images au format PPP sur un ‚cran VGA. Le seul paramŠtre de
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
    u_ppp;

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
   pic : p_ppp;
   prog : o_prg;
   old_dir : string;

procedure lit_image (nom : string); forward;

constructor o_prg.init;
begin
     o_fdtree.init;
     set_file_mask ('*.ppp');
end; { o_prg.init }

function o_prg.treat_file (f : searchrec) : boolean;
begin
     lit_image (f.name);
     ppp_affiche (pic);
     ppp_done (pic);
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
begin
     pic := ppp_load (nom);
end; { lit_image }

begin
     init_licence ('slide');
     init_olf_message (mess_freeware);
     init_ligne_olf_software ('Slide PPP '+num_vers, '(c) Patrick Pr‚martin '+dat_vers);
     if (param_del ('/?') or param_del ('/H'))
     then
         begin
              writeln;
              writeln ('Syntax:');
              writeln ('     SLIDEPPP [/?|/H] [PATH_NAME]');
              writeln;
              writeln ('Use this program to see all PPP pictures in PATH_NAME and its');
              writeln ('sub-directories. VGA GRAPHICS CARD ONLY...');
              writeln;
         end
     else
         begin
              getdir (0, old_dir);
              prog.init;
              if ((set_mode (19)) and (paramcount = 1))
              then
                  prog.set_start_directory (paramstr (1))
              else
                  prog.set_start_directory (old_dir);
              {endif}
              prog.run;
              prog.done;
              chdir (old_dir);
              repeat
              until (set_mode (3) or TRUE);
         end;
     {endif}
end.
