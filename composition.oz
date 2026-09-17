% Proyecto OOP
% David Octavio Ibarra
% Sebastian Rojas


%Crear el objeto Employer
declare
fun {NewEmployer InitName InitAddress}

   local Name Address Attributes GetName GetAddress Display in
   Name = {NewCell InitName}
   Address = {NewCell InitAddress}

   fun{Attributes}
      attributes(name:Name address:Address)
   end

   fun {GetName} 
      @Name
   end

   fun {GetAddress}
      @Address
   end

   proc {Display}
      {Browse  "Employer:"}
      {Browse @Name}
      {Browse @Address}
   end
   
   employer(name:GetName address:GetAddress display:Display attributes:Attributes) 
   end
end

%Función para crear el objeto Person
declare
fun {NewPerson InitName InitEmployer}

   local Name Employer Attributes PersonName PersonEmployer Display in
      Name = {NewCell InitName}
      Employer = {NewCell InitEmployer}

      fun {Attributes}
         attributes(name:Name employer:Employer)
      end

      fun {PersonName} 
         @Name 
      end

      fun {PersonEmployer}
         {@Employer.name} 
      end

      proc {Display}
         {Browse "Person"}
         {Browse "Name: "#@Name}
      end
      person(personName:PersonName personEmployer:PersonEmployer display:Display attributes:Attributes)
   end
end



% Prueba

local Emp Per in
   Emp = {NewEmployer "Uniandes" "Bogota"}
   Per = {NewPerson "David" Emp}
   {Show {Emp.name}}
   {Show {Emp.address}}
   {Emp.display}

   {Show {Per.personName}}
   {Show {Per.personEmployer}}
   {Per.display}
end