## DeLaFits

DeLaFits is a Delphi and Lazarus library for operations with data in [Flexible Image Transport System](http://fits.gsfc.nasa.gov "http://fits.gsfc.nasa.gov") format.  

- building
- reading 
- editing
- rendering  

Uses a regions for data access and creation of a graphic image of data.  
Supports only Single Image - one header and one data unit.

### How to use

Just copy and add `Source` directory in your project.  

- DeLaFitsCommon.pas - common constants and simple functions
- DeLaFitsClasses.pas - access to header and data - building, reading, editing
- DeLaFitsGraphics.pas - rendering of the data - creation of a graphic image  

For details, see [User's Guide](http://felleroff.github.io/delafits).

### Class Hierarchy

![class-hierarchy.png](https://raw.githubusercontent.com/felleroff/delafits/master/class-hierarchy.png "Class Hierarchy")

### Code Sample

```delphi
var
  Fit: TFitsFileBitmap;
  I, X, Y: Integer;
  Item: TLineItem;
  Rgn: TRgn;
  Data: array of array of Integer;
  Bmp: TBitmap;
begin
  Fit := TFitsFileBitmap.CreateJoin('some.fit', cFileReadWrite);
  Data := nil;
  Bmp := nil;
  try
    // edit header
    I := Fit.LineBuilder.IndexOf('DATE-OBS');
    if I >= 0 then
    begin
      Fit.LineBuilder.ValuesDateTime[I] := Now;
      Fit.LineBuilder.Notes[I] := 'Set datetime';
    end
    else
    begin
      Item.Keyword       := 'DATE-OBS';
      Item.ValueIndicate := True;
      Item.Value.Dtm     := Now;
      Item.NoteIndicate  := True;
      Item.Note          := 'Add datetime';  
      Fit.LineBuilder.Add(Item, cCastDateTime);
    end;   
    // edit data
    Rgn.X1     := 0;
    Rgn.Y1     := 0;
    Rgn.Width  := 200;
    Rgn.Height := 200;
    Fit.DataRep := rep32c;
    Fit.DataPrepare(Pointer(Data), Rgn);
    Fit.DataRead(Pointer(Data), Rgn); 
    for Y := 0 to Rgn.RowsCount - 1 do
    for X := 0 to Rgn.ColsCount - 1 do
      Data[X, Y] := Data[X, Y] + 1; 
    Fit.DataWrite(Pointer(Data), Rgn);    
    // render
    Bmp := TBitmap.Create;
    Rgn.X1        := 0;
    Rgn.Y1        := 0;
    Rgn.ColsCount := 200;
    Rgn.RowsCount := 200;
    Fit.GraphicColor.ToneContrast := 1.2;
    Fit.GraphicGeom.Scl(2.0, 2.0, xy00).Rot(45.0, xy00);
    Fit.BitmapRead(Bmp, Rgn);
    Bmp.SaveToFile('some.bmp');    
  finally
    Fit.Free;
    Bmp.Free;
    Data := nil;
  end;
end;
```  

### Credits

DeLaFits is developed and used in the [CoLiTec](http://www.neoastrosoft.com "http://www.neoastrosoft.com") project (software for automated asteroids and comets discoveries).

### License

[MIT](https://github.com/felleroff/delafits/blob/master/LICENSE) © 2013-2016, Evgeniy Dikov \<delafits.library@gamil.com\>
