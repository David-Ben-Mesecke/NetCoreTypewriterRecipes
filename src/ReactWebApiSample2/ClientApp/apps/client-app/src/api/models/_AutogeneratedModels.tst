${
    using System.Text;
    using System.Text.RegularExpressions;
    using Typewriter.Extensions.Types;
    
    Template(Settings settings)
    {
        settings
            .IncludeCurrentProject()
            .IncludeReferencedProjects()
            ;
    }

    bool IncludeClass(Class c){
        if(!c.Namespace.StartsWith("ReactWebApiSample"))
        {
            return false;
        }

        var attr = c.Attributes.FirstOrDefault(p => p.Name == "GenerateFrontendType");
        if(attr == null){
            return false;
        }

        var parent = c.BaseClass;
        if(parent != null){
            if(parent.Name.EndsWith("Controller")
          || parent.Name.EndsWith("ControllerBase"))
          {
            return false;
          }
        }        

        return true;
    }

    bool IncludeRecord(Record r){
        if(!r.Namespace.StartsWith("ReactWebApiSample"))
        {
            return false;
        }

        var attr = r.Attributes.FirstOrDefault(p => p.Name == "GenerateFrontendType");
        if(attr == null){
            return false;
        }

        var parent = r.BaseRecord;
        if(parent != null){
            if(parent.Name.EndsWith("Controller")
          || parent.Name.EndsWith("ControllerBase"))
          {
            return false;
          }
        }        

        return true;
    }

    bool IncludeEnums(Enum e){
        if(!e.Namespace.StartsWith("ReactWebApiSample"))
        {
            return false;
        }

        var attr = e.Attributes.FirstOrDefault(p => p.Name == "GenerateFrontendType");
        if(attr == null){
            return false;
        }

        return true;
    }

    string ImportClass(Class c)
    {
        var neededImports = c.Properties
          .Where(p => (!p.Type.IsPrimitive || p.Type.IsEnum) && (p.Type.ClassName() != "string" && p.Type.ClassName() != "any" && p.Type.ClassName() != "T") && IncludeProperty(p))
          .Select(p => $"import {{ {p.Type.ClassName()} }} from './{p.Type.ClassName()}';").ToList();
    
        if(c.BaseClass != null && c.BaseClass.TypeArguments != null)
        {
            foreach(var typeArgument in c.BaseClass.TypeArguments)
            {
                neededImports.Add($"import {{ I{typeArgument.Name}, {typeArgument.Name} }} from './{typeArgument.Name}';");
            }
        }

        if(c.BaseClass != null)
        {
            neededImports.Add($"import {{ I{c.BaseClass.ToString()}, {c.BaseClass.ToString()} }} from './{c.BaseClass.ToString()}';");
        }

        return String.Join(Environment.NewLine, neededImports.Distinct());
    }

    string ImportRecord(Record r)
    {
        var neededImports = r.Properties
          .Where(p => (!p.Type.IsPrimitive || p.Type.IsEnum) && (p.Type.ClassName() != "string" && p.Type.ClassName() != "any" && p.Type.ClassName() != "T") && IncludeProperty(p))
          .Select(p => $"import {{ {p.Type.ClassName()} }} from './{p.Type.ClassName()}';").ToList();
    
        if(r.BaseRecord != null && r.BaseRecord.TypeArguments != null)
        {
            foreach(var typeArgument in r.BaseRecord.TypeArguments)
            {
                neededImports.Add($"import {{ I{typeArgument.Name}, {typeArgument.Name} }} from './{typeArgument.Name}';");
            }
        }

        if(r.BaseRecord != null)
        {
            neededImports.Add($"import {{ I{r.BaseRecord.ToString()}, {r.BaseRecord.ToString()} }} from './{r.BaseRecord.ToString()}';");
        }

        return String.Join(Environment.NewLine, neededImports.Distinct());
    }

    string InheritClass(Class c)
    {
        if(c.BaseClass != null)
        {
            if(c.BaseClass.IsGeneric)
            {
                return $" extends {c.BaseClass.ToString()}<{c.BaseClass.TypeArguments.First()}>";
            }
            else
            {
                return $" extends {c.BaseClass.ToString()}";
            }
        }
        else
        {
            return string.Empty;
        }
    }

    string InheritRecord(Record r)
    {
        if(r.BaseRecord != null)
        {
            if(r.BaseRecord.IsGeneric)
            {
                return $" extends {r.BaseRecord.ToString()}<{r.BaseRecord.TypeArguments.First()}>";
            }
            else
            {
                return $" extends {r.BaseRecord.ToString()}";
            }
        }
        else
        {
            return string.Empty;
        }
    }

    string InheritInterfaceForClass(Class c)
    {
        if(c.BaseClass != null)
        {
            if(c.BaseClass.IsGeneric)
            {
                return $" extends I{c.BaseClass.ToString()}<{c.BaseClass.TypeArguments.First()}>";
            }
            else
            {
                return $" extends I{c.BaseClass.ToString()}";
            }
        }
        else
        {
            return string.Empty;
        }
    }

    string InheritInterfaceForRecord(Record r)
    {
        if(r.BaseRecord != null)
        {
            if(r.BaseRecord.IsGeneric)
            {
                return $" extends I{r.BaseRecord.ToString()}<{r.BaseRecord.TypeArguments.First()}>";
            }
            else
            {
                return $" extends I{r.BaseRecord.ToString()}";
            }
        }
        else
        {
            return string.Empty;
        }
    }

    string ImplementsInterfaceForClass(Class c)
    {
        if(c.IsGeneric)
        {
            return $" implements I{c.ToString()}<{c.TypeArguments.First()}>";
        }
        else
        {
            return $" implements I{c.ToString()}";
        }
    }

    string ImplementsInterfaceForRecord(Record r)
    {
        if(r.IsGeneric)
        {
            return $" implements I{r.ToString()}<{r.TypeArguments.First()}>";
        }
        else
        {
            return $" implements I{r.ToString()}";
        }
    }

    string SuperClass(Class c){
        if(c.BaseClass == null)
        {
            return string.Empty;
        }
        return $"{Environment.NewLine}        super(initObj);";
    }

    string SuperRecord(Record r){
        if(r.BaseRecord == null)
        {
            return string.Empty;
        }
        return $"{Environment.NewLine}        super(initObj);";
    }

    string GetDiscriminator(AttributeCollection attributes) {
        var discriminator = "$type";
        var attr = attributes.FirstOrDefault(p => p.Name == "JsonPolymorphic");
        if(attr != null && !string.IsNullOrEmpty(attr.Value)) {
            var regex = new Regex(@"TypeDiscriminatorPropertyName\s*=\s*[""]([^""]*)[""]");
            discriminator = regex.Replace(attr.Value, "$1");
        }
        return discriminator;
    }

    string GenerateTypeForInterfaceByClass(Class c){
        var returnValue = string.Empty;
        if(c.BaseClass == null && c.Attributes.Any(a => a.Name == "JsonDerivedType"))
        {
            var discriminator = GetDiscriminator(c.Attributes);
            returnValue = $"{Environment.NewLine}    {discriminator}?: string | number;";
        }
        return returnValue;
    }

    string GenerateTypeForInterfaceByRecord(Record r){
        var returnValue = string.Empty;
        if(r.BaseRecord == null && r.Attributes.Any(a => a.Name == "JsonDerivedType"))
        {
            var discriminator = GetDiscriminator(r.Attributes);
            returnValue = $"{Environment.NewLine}    {discriminator}?: string | number;";
        }
        return returnValue;
    }

    string GenerateTypeForClass(Class c){
        var returnValue = string.Empty;
        if(c.BaseClass == null && c.Attributes.Any(a => a.Name == "JsonDerivedType"))
        {
            var discriminator = GetDiscriminator(c.Attributes);
            returnValue = $"{Environment.NewLine}    public {discriminator}?: string | number;";
        }
        return returnValue;
    }

    string GenerateTypeForRecord(Record r){
        var returnValue = string.Empty;
        if(r.BaseRecord == null && r.Attributes.Any(a => a.Name == "JsonDerivedType"))
        {
            var discriminator = GetDiscriminator(r.Attributes);
            returnValue = $"{Environment.NewLine}    public {discriminator}?: string | number;";
        }
        return returnValue;
    }

    string GenerateTypeInitForClass(Class c){
        var baseClass = c.BaseClass;
        while (baseClass?.BaseClass != null) {
            baseClass = baseClass.BaseClass;
        }

        string discriminator;
        if(baseClass == null) {
            discriminator = GetDiscriminator(c.Attributes);
            return $"this.{discriminator} = undefined;";
        }
       
        discriminator = GetDiscriminator(baseClass.Attributes);
        
        var attrs = baseClass.Attributes.Where(p => p.Name == "JsonDerivedType");
        var regex1 = new Regex(@"\s*typeof\s*[(]\s*([^)\s]+)[)].*");
        var regexString = new Regex(@"[^,]*[,]\s*[""]([^""]*)[""].*");
        var regexNumber = new Regex(@"[^,]*[,]\s*(\d).*");
        foreach (var attr in attrs) {
            var typeName = regex1.Replace(attr.Value, "$1");
            if(typeName == c.FullName) {
                if (regexString.IsMatch(attr.Value)) {
                  var value = regexString.Replace(attr.Value, "$1");
                  return $"this.{discriminator} = '{value}';";
                }
                else if (regexNumber.IsMatch(attr.Value)) {
                  var value = regexNumber.Replace(attr.Value, "$1");
                  return $"this.{discriminator} = {value};";
                }
            }
        }

        return $"this.{discriminator} = undefined;";
    }

    string GenerateTypeInitForRecord(Record r){
        var dllName = r.Namespace;
        var attr = r.Attributes.FirstOrDefault(p => p.Name == "GenerateFrontendType");
        if(attr != null && !string.IsNullOrEmpty(attr.Value)) {
            dllName = attr.Value;
        }
        return $"this.$type = '{r.FullName},'\r\n            + '{dllName}';";
    }

    string SimplifyType(Property property){
        var typeName = property.Type.Name;
        if(typeName == "string") {
            return "string | null";
        }
        return property.Type.Name;
    }

    string NullableMark(Property property) {
      return property.Type.IsNullable ? "?" : string.Empty;
    }

    string ReturnTypeDefault(Type type) {
        return type.Default().Replace("\"", $"{(char)39}");
    }

    string GetAttributeValueOrReturnEnumNameIfNoAttribute(EnumValue enumObj) {
        if (enumObj.Attributes.Any(a=>a.Name=="LabelForEnum")) {
            return enumObj.Attributes.First(a=>a.Name=="LabelForEnum").Value;
        } else {
            return enumObj.Name;
        }
    }

    bool IsEnumAsNumber(Enum e) {
      if(e.Attributes.Any(a=>a.Name=="AsString")){
        return false;
      }
      return true;
    }

    string GetEnumAsStringIfItsStringable(EnumValue enumObj) {
        var parent = (enumObj.Parent as Enum);
        if(parent.Attributes.Any(a=>a.Name=="AsString")){
            return "'"+enumObj.Name+"'";
        } else {
            return enumObj.Value.ToString();
        }
    }

    bool IncludeProperty(Property property) {
        var attr = property.Attributes.FirstOrDefault(p => p.Name == "JsonIgnore");
        if(attr != null){
            return false;
        }
        return true;
    }
}// This file has been AUTOGENERATED by TypeWriter (https://frhagn.github.io/Typewriter/).
// Do not modify it.
$Enums($IncludeEnums)[
export enum $Name {$Values[
    $Name = $GetEnumAsStringIfItsStringable][,
    ]
}

export namespace $Name {
    export function getLabel(value: $Name): string {
        var toReturn = '';
        switch(value) {$Values[
            case $Parent[$Name].$Name: toReturn = '$GetAttributeValueOrReturnEnumNameIfNoAttribute'; break;][
            ]
        }
        return toReturn;
    } $IsEnumAsNumber[
    export function getKeys(): Array<number> {
        var list = new Array<number>();
        for (var enumMember in $Name) { 
            if (parseInt(enumMember, 10) < 0) {
                  continue;
            }
            list.push(parseInt(enumMember, 10));
        }

        return list;
    }]
}
]
$Classes($IncludeClass)[
$ImportClass

export interface I$Name$TypeParameters$InheritInterfaceForClass {$GenerateTypeForInterfaceByClass$Properties($IncludeProperty)[
    $name?: $SimplifyType;]
}

export class $Name$TypeParameters$InheritClass$ImplementsInterfaceForClass {$GenerateTypeForClass$Properties($IncludeProperty)[
    public $name$NullableMark: $SimplifyType;]

    constructor(initObj?: I$Name$TypeParameters) {$SuperClass
        $GenerateTypeInitForClass
        if (initObj) {$Properties($IncludeProperty)[
            this.$name = initObj.$name || $Type[$ReturnTypeDefault];]
        } else {$Properties($IncludeProperty)[
            this.$name = $Type[$ReturnTypeDefault];]
        }
    }
}]
$Records($IncludeRecord)[
$ImportRecord

export interface I$Name$TypeParameters$InheritInterfaceForRecord {$GenerateTypeForInterfaceByRecord$Properties($IncludeProperty)[
    $name?: $SimplifyType;]
}

export class $Name$TypeParameters$InheritRecord$ImplementsInterfaceForRecord {$GenerateTypeForRecord$Properties($IncludeProperty)[
    public $name$NullableMark: $SimplifyType;]

    constructor(initObj?: I$Name$TypeParameters) {$SuperRecord
        $GenerateTypeInitForRecord
        if (initObj) {$Properties($IncludeProperty)[
            this.$name = initObj.$name || $Type[$ReturnTypeDefault];]
        } else {$Properties($IncludeProperty)[
            this.$name = $Type[$ReturnTypeDefault];]
        }
    }
}]

