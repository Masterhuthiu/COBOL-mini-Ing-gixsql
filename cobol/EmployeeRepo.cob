       class-id. ExampleClass inherits Base.

       factory.
       data division.
       working-storage section.
       01 StaticMessage string value "Xin chào từ Factory!".

       procedure division.
       method-id. NewExample static.
           procedure division returning obj as ExampleClass.
               set obj to new ExampleClass
           end method NewExample.

       method-id. PrintStaticMessage static.
           procedure division.
               display StaticMessage
           end method PrintStaticMessage.
       end factory.

       object. implements IInterfaceName.
       data division.
       working-storage section.
       01 InstanceMessage string value "Xin chào từ Object!".

       procedure division.
       method-id. InstanceMethod.
           procedure division.
               display InstanceMessage
           end method InstanceMethod.
       end object.

       end class ExampleClass.
