program siaod1_4;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

type
  data = record
  tel : string[7];
  opis : string[20];
  end;

  TList = ^elem;
  elem = record
  info : data;
  next : TList;
  end;


function NomerOperacii:integer;
var a : integer;
    oper : set of Byte;
    flag : boolean;
begin
oper := [1, 2, 3, 4];
writeln('Выберите операцию, которую необходимо провести над списком.');
  writeln('1 - Добавление новой записи в телефонную книгу.');
  writeln('2 - Вывести весь список.');
  writeln('3 - Вывести список абонентов, без телефонов спецслужб.');
  writeln('4 - Закончить работу программы.');
flag := false;
repeat
readln(a);
if a in oper then
  flag := true
else
  writeln('Введите корректный номер операции!');
until flag = true;
result:=a;
end;


procedure whattodo(oper:integer; head:TList);
var iskomoe :string[20];


procedure ShowList(head : TList);
var curr:TList;
begin
curr:=head.next;
writeln(curr.info.tel,' ', curr.info.opis);
while curr.next<>nil do
begin
curr:=curr.next;
writeln(curr.info.tel,' ', curr.info.opis);
end;
end;

procedure ShowList_spec(head : TList);
var curr:TList;
begin
curr:=head.next;
writeln(curr.info.tel,' ', curr.info.opis);
while curr.next<>nil do
begin
curr:=curr.next;
if  length(curr.info.tel)=3 then
  begin
  writeln(curr.info.tel,' ', curr.info.opis);
  end;
end;
end;

procedure AddNewElem(head:TList);

function EnterElem:data;
var new:elem;
begin
writeln('Введите номер телефона:');
readln(new.info.tel);
writeln('Введите описание номера (Фамилию и инициалы, если это абонент, название спецслужбы, если нет):');
readln(new.info.opis);
result := new.info;
end;

var curr:Tlist;
f:file of data;
i:integer;

begin
assignfile(f,'spisoknomerov.dat');
i:=0;
curr:=head.next;
writeln('Введите данные нового абонента.');
while curr.next<>nil do
begin
curr:=curr.next;
inc(i);
end;
new(curr.next);
curr:=curr.next;
curr.info:=EnterElem;
curr.next:=nil;
inc(i);
reset(f);
seek(f,i);
write(f,curr.info);
closefile(f);
end;

begin
 case oper of
  1:
    begin
    AddNewElem(head);
    oper:=NomerOperacii;
    whattodo(oper,head);
    end;
  2:
    begin
    showlist(head);
    oper:=NomerOperacii;
    whattodo(oper,head);
    end;
  3:
    begin
    showlist_spec(head);
    oper:=NomerOperacii;
    whattodo(oper,head);
    end;

  4:   writeln('Ок.');
  end;
end;

 //___________________________

var curr,first : TList;
    f : file of data;
    t : textfile;
    file_exist : boolean;
    oper, i : integer;

begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);

Assignfile(f, 'spisoknomerov.dat');
   try
   Reset(f);
   file_exist := true;
   except
   writeln('Файл с номерами не существует');
   file_exist := false;
   end;




if (file_exist = true) and (not eof(f)) then
begin
i := 0;
new(first);
curr:=first;
new(curr.next);
curr:=curr.next;
seek(f, i);
read(f, curr.info);
while (not eof(f)) do
  begin
  new(curr.next);
  curr := curr.next;
  inc(i);
  seek(f, i);
  read(f, curr.info);
  curr.next:=nil;
  end;
closefile(f);

oper:=NomerOperacii;
whattodo(oper,first);

  end;



readln;
end.
