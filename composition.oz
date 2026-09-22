% Proyecto OOP
% David Octavio Ibarra
% Sebastian Rojas
functor
import
   Browser(browse:Browse)
   System(showInfo:Show show:ShowValue)


define
%Crear el objeto Employer
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
         {Browse "Employer"}
         {Browse "Name: "#@Name}
         {Browse "Address: "#@Address}
      end
      
      employer(name:GetName address:GetAddress display:Display attributes:Attributes) 
      end
   end

   %Función para crear el objeto Person
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
   
   %Funcion Composicion Explicita
   fun {ExplicitComposition Objects}
      fun {Loop Remaining Acc}
         case Remaining
         of nil then Acc
         [] Obj|Rest then
            local Methods MergedAttributes CombinedAttributes Combined in
               Methods = {MergeKeepingFirst Acc Obj}
               MergedAttributes = {MergeKeepingFirst {Acc.attributes} {Obj.attributes}}
               fun {CombinedAttributes}
                  MergedAttributes
               end
               Combined = {AdjoinAt Methods attributes CombinedAttributes}
               {Loop Rest Combined}
            end
         end
      end
      in 
         {Loop Objects composed(attributes:fun {$} attributes end)}
   end

   % Task 4: Explicit composition with poly methods
   fun {ExplicitCompositionPoly Objects}
      fun {Loop Remaining Acc Seen}
         case Remaining
         of nil then Acc
         [] Obj|Rest then
            if {Member Obj Seen} then
               {Loop Rest Acc Seen}
            else
               local Methods MergedAttributes CombinedAttributes Combined in
                  Methods = {AddMethods {Arity Obj} Obj Acc}
                  MergedAttributes = {MergeKeepingFirst {Acc.attributes} {Obj.attributes}}
                  fun {CombinedAttributes}
                     MergedAttributes
                  end
                  Combined = {AdjoinAt Methods attributes CombinedAttributes}
                  {Loop Rest Combined Obj|Seen}
               end
            end
         end
      end
   in
      {Loop Objects composed(attributes:fun {$} attributes end) nil}
   end

   %Task 3: Implicit composition:
   fun {Union L1 L2}
      case L2
      of nil then L1
      [] X|Rest then
         if {Member X L1} then {Union L1 Rest}
         else {Union {Append L1 [X]} Rest}
         end
      end
   end

   fun {ImplicitComposition Objects}
      fun {FindIn Objs Feature}
         case Objs
         of nil then notFound
         [] Obj|Rest then
            if {HasFeature Obj Feature} then
               Obj.Feature
            else
               {FindIn Rest Feature}
            end
         end
      end

      fun {CollectFeatures Objs Acc}
         case Objs
         of nil then Acc
         [] Obj|Rest then
            {CollectFeatures Rest {Union Acc {Arity Obj}}}
         end
      end

      fun {BuildRecord Features}
         case Features
         of nil then composed()
         [] F|Rest then
            if F == attributes then
               {BuildRecord Rest}
            else
               {AdjoinAt {BuildRecord Rest} F {FindIn Objects F}}
            end
         end
      end

      fun {MergeAllAttributes Objs Acc}
         case Objs
         of nil then Acc
         [] Obj|Rest then
            {MergeAllAttributes Rest {MergeKeepingFirst Acc {Obj.attributes}}}
         end
      end

      AllFeatures = {CollectFeatures Objects nil}
      MergedAttrs = {MergeAllAttributes Objects attributes()}

      fun {CombinedAttributes}
         MergedAttrs
      end
   in
      {AdjoinAt {BuildRecord AllFeatures} attributes CombinedAttributes}
   end


   %Task 5: select the first implementation and pass it one argument.
   proc {Dispatch Object Selector Argument}
      case Object.Selector
      of Method|_ then
         {Method Argument}
      end
   end

   %Helper for poly composition: retain methods as ordered lists.
   fun {AddMethods Features Obj Acc}
      case Features
      of nil then Acc
      [] Feature|Rest then
         if Feature == attributes then
            {AddMethods Rest Obj Acc}
         else
            local Implementations in
               if {HasFeature Acc Feature} then
                  Implementations = {Append Acc.Feature [Obj.Feature]}
               else
                  Implementations = [Obj.Feature]
               end
               {AddMethods Rest Obj {AdjoinAt Acc Feature Implementations}}
            end
         end
      end
   end

   %Helper MergeKeepingFirst merges 2 records
   fun {MergeKeepingFirst First Second}
      fun {Loop Features Acc}
         case Features
         of nil then Acc
         [] Feature|Rest then
            if {HasFeature Acc Feature} then
               {Loop Rest Acc}
            else
               {Loop Rest
                  {AdjoinAt Acc Feature Second.Feature}}
            end
         end
      end
      in
         {Loop {Arity Second} First}  
   end

   
   % Task 6: Se modifica Dispatch añadiéndole el índice
   proc {Dispatch Object Selector Argument Index}
      local Methods in
         Methods = Object.Selector
         if Index =< {Length Methods} then
            {{Nth Methods Index} Argument}
         else
            skip
         end
      end
   end
end
