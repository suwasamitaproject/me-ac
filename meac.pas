program MEAC_ParkingSystem;
uses crt;

const
  MAX_PARKIR = 50; // kapasitas maksimal parkiran

var

  pilihanMenu, i, j, jmlKendaraan: integer;
  
  // Array untuk nyimpen database sementara
  platData: array[1..MAX_PARKIR] of string;
  jenisData: array[1..MAX_PARKIR] of char;
  jamMasukData: array[1..MAX_PARKIR] of integer;

  platKeluar: string;
  jamKeluar, durasi: integer;
  biayaTotal: longint;
  isKetemu: boolean;
  member: char;

begin
  jmlKendaraan := 0;

  // Efek booting ala Mainframe (Pakai For-To-Do)
  clrscr;
  writeln('System Initializing...');
  write('Booting M.E. A.C. ');
  for i := 1 to 10 do
  begin
    write('.');
    delay(200); // delay biar ada efek loadingnya
  end;
  writeln;
  writeln('Booting selesai! Press Enter to start.');
  readln;

  // MENU INTERAKTIF (Pakai Repeat-Until)
  repeat
    clrscr;
    writeln('-------------------/ /-------------------');
    writeln('    MAINFRAME ENTRY & ACCESS CONTROL (M.E. A.C)   ');
    writeln('            SISTEM PARKIR VERSI 1.0               ');
    writeln('-------------------/ /-------------------');
    writeln('1. Entry Kendaraan Masuk');
    writeln('2. Checkout Kendaraan Keluar');
    writeln('3. Lihat Database Parkiran (Admin Only)');
    writeln('4. Shutdown System');
    writeln('-------------------/ /-------------------');
    write('Pilih menu [1-4]: ');
    readln(pilihanMenu);

    // PENGKONDISIAN (Pakai Case-Of)
    case pilihanMenu of
      1:
      begin
        clrscr;
        writeln('-- ENTRY KENDARAAN MASUK --');
        
        if jmlKendaraan >= MAX_PARKIR then
        begin
          writeln('Error: Kapasitas Parkir Penuh!');
        end
        else
        begin
          jmlKendaraan := jmlKendaraan + 1;
          
          // INPUT/OUTPUT
          write('Masukkan Plat Nomor      : '); readln(platData[jmlKendaraan]);
          write('Jenis [M: Mobil/S: Motor]: '); readln(jenisData[jmlKendaraan]);
          write('Jam Masuk [0-23]         : '); readln(jamMasukData[jmlKendaraan]);

          writeln;
          writeln('Data berhasil direkam ke Mainframe!');
        end;
        write('Tekan Enter untuk kembali...');
        readln;
      end;

      2:
      begin
        clrscr;
        writeln('-- CHECKOUT & PAYMENT --');
        if jmlKendaraan = 0 then
        begin
           writeln('Parkiran masih kosong coy, ga ada yang bisa di-checkout.');
        end
        else
        begin
          write('Input Plat Nomor yang keluar: ');
          readln(platKeluar);

          isKetemu := false;
        
          for i := 1 to jmlKendaraan do
          begin
            if upcase(platData[i]) = upcase(platKeluar) then
            begin
              isKetemu := true;
              write('Jam Keluar [0-23]           : '); readln(jamKeluar);

              // NESTED IF: Logika ngitung durasi (jaga-jaga kalau dia nginap lewat jam 12 malam)
              if jamKeluar >= jamMasukData[i] then
              begin
                durasi := jamKeluar - jamMasukData[i];
              end
              else
              begin
                durasi := (24 - jamMasukData[i]) + jamKeluar;
              end;

              if durasi = 0 then durasi := 1; // minimal dihitung 1 jam

              // NESTED IF: Nentuin tarif dasar berdasarkan jenis kendaraan
              if upcase(jenisData[i]) = 'M' then
              begin
                biayaTotal := 5000 + ((durasi - 1) * 2000); // 5rb sejam pertama, next 2rb
              end
              else if upcase(jenisData[i]) = 'S' then
              begin
                biayaTotal := 2000 + ((durasi - 1) * 1000); // 2rb sejam pertama, next 1rb
              end
              else
              begin
                biayaTotal := 10000; // default tarif kalau input jenisnya ngaco
              end;

              // PENGKONDISIAN: Cek member
              writeln('Punya kartu member M.E. A.C? [Y/N]');
              write('Jawaban: '); readln(member);

              if upcase(member) = 'Y' then
              begin
                writeln('>> Member detected. Diskon 20% diaplikasikan.');
                biayaTotal := biayaTotal - (biayaTotal * 20 div 100);
              end;

              writeln;
              writeln('__̴ı̴̴̡̡̡ ̡͌l̡̡̡ ̡͌l̡*̡̡ ̴̡ı̴̴̡ ̡̡͡|̲̲̲͡͡͡ ̲▫̲͡ ̲̲̲͡͡π̲̲͡͡ ̲̲͡▫̲̲͡͡ ̲|̡̡̡ ̡ ̴̡ı̴̡̡ ̡͌l̡̡̡̡.___');
              writeln('STRUK PARKIR M.E. A.C.');
              writeln('Plat Nomor : ', upcase(platData[i]));
              writeln('Durasi     : ', durasi, ' Jam');
              writeln('Total Bayar: Rp ', biayaTotal);
              writeln('__̴ı̴̴̡̡̡ ̡͌l̡̡̡ ̡͌l̡*̡̡ ̴̡ı̴̴̡ ̡̡͡|̲̲̲͡͡͡ ̲▫̲͡ ̲̲̲͡͡π̲̲͡͡ ̲̲͡▫̲̲͡͡ ̲|̡̡̡ ̡ ̴̡ı̴̡̡ ̡͌l̡̡̡̡.___');

              // Hapus data dari array (geser datanya ke kiri)
              for j := i to jmlKendaraan - 1 do
              begin
                platData[j] := platData[j+1];
                jenisData[j] := jenisData[j+1];
                jamMasukData[j] := jamMasukData[j+1];
              end;
              jmlKendaraan := jmlKendaraan - 1; // kurangi jumlah mobil di parkiran

              // PELONCATAN: Kalau udah ketemu dan dibayar, langsung stop perulangan pencariannya
              break; 
            end;
          end;

          // Kalau loop selesai tapi ga ketemu
          if isKetemu = false then
            writeln('Plat nomor ngga ketemu di Mainframe. Coba cek lagi.');
        end;

        write('Tekan Enter untuk kembali...');
        readln;
      end;

      3:
      begin
        clrscr;
        writeln('-- DAFTAR KENDARAAN (MAINFRAME DB) --');
        if jmlKendaraan = 0 then
        begin
          writeln('Database kosong.');
        end
        else
        begin
          // PERULANGAN (Pakai While-Do)
          i := 1;
          while i <= jmlKendaraan do
          begin
            // PELONCATAN: Fitur rahasia, kalau ada plat ADMIN, jangan di-print ke layar (skip)
            if upcase(platData[i]) = 'ADMIN' then
            begin
              i := i + 1;
              continue; // Langsung lompat ke iterasi loop berikutnya
            end;

            writeln(i, '. Plat: ', upcase(platData[i]), ' | Tipe: ', upcase(jenisData[i]), ' | Masuk jam: ', jamMasukData[i], ':00');
            i := i + 1;
          end;
          writeln;
          writeln('*Note: Kendaraan operasional (ADMIN) disembunyikan dari list publik.');
        end;
        write('Tekan Enter untuk kembali...');
        readln;
      end;

      4:
      begin
        writeln('Shutting down M.E. A.C. Mainframe...');
        delay(1000);
      end;

    else
      begin
        writeln('Input ga valid, pilih 1-4 aja bro.');
        delay(1000);
      end;
    end;

  until pilihanMenu = 4;
end.