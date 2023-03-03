Class {
	#name : #DRSlangCompiler,
	#superclass : #Object,
	#category : #'Druid-Slang'
}

{ #category : #compiling }
DRSlangCompiler class >> exportPackage: aPackage To: aFileReference [ 

	self new exportPackage: aPackage To: aFileReference 
]

{ #category : #'api-translation' }
DRSlangCompiler class >> exportPepita [

	<script>
	| programClasses cg translationClasses structClasses aFileReference dir file |
	"This is the main Slang API to translate a program from a class.
	It 
	  - takes all the ancilliary classes from this one, separating structs from non structs
	  - create a code generator from them
	  - run type inference
	  - output the translated program to the desired file"
	dir := '/Users/palumbon/Documents/Pharo/repos/Slang-example/generated'
		       asFileReference.
	file := dir / 'Pepita.c'.
	aFileReference := file asFileReference.
	programClasses := { Entrenador_Slang }.

	SlangStructType voidStructTypeCache. "Clear cache to detect new defined structs"
	cg := CCodeGenerator new.

	translationClasses := programClasses
	                      ,
	                      (cg nonStructClassesForTranslationClasses:
		                       programClasses).
	structClasses := cg structClassesForTranslationClasses:
		                 programClasses.

	cg addStructClasses: structClasses.
	translationClasses do: [ :ic | cg addClass: ic ].

	cg inferTypes.

	cg storeCodeOnFile: aFileReference doInlining: false
]

{ #category : #'api-translation' }
DRSlangCompiler class >> exportTo: aFileReference [

	| programClasses cg translationClasses structClasses |
	"This is the main Slang API to translate a program from a class.
	It 
	  - takes all the ancilliary classes from this one, separating structs from non structs
	  - create a code generator from them
	  - run type inference
	  - output the translated program to the desired file"
	
	programClasses := { Entrenador }.

	SlangStructType voidStructTypeCache. "Clear cache to detect new defined structs"
	cg := CCodeGenerator new.

	translationClasses := programClasses, (cg nonStructClassesForTranslationClasses: programClasses).
	structClasses := cg structClassesForTranslationClasses: programClasses.

	cg addStructClasses: structClasses.
	translationClasses do: [ :ic | cg addClass: ic.  ].

	cg inferTypes.

	cg storeCodeOnFile: aFileReference doInlining: false.
]

{ #category : #compilation }
DRSlangCompiler >> compileClasses: aPackage [

	| targetPackage builders |
	targetPackage := aPackage name asSlangCompiled asPackage.

	builders := aPackage classes
		reject: [ :c | c isTestCase ]
		thenCollect: [ :class | self slangBuilderOf: class ].
		
	builders do: [ :b | b createClassOn: targetPackage ]. "First create all empty classes"
	builders do: [ :b | b addDefinitions ]. "Then transform methods"
]

{ #category : #compilation }
DRSlangCompiler >> createNewPackageFor: aPackage [

	| newPackageName |
	newPackageName := aPackage name asSlangCompiled.
	(RPackageOrganizer default includesPackageNamed: newPackageName) ifTrue: [ 
		 newPackageName asPackage removeFromSystem ].
	RPackageOrganizer default createPackageNamed: newPackageName
]

{ #category : #API }
DRSlangCompiler >> exportMain: mainClass to: aFileReference [

	| programClasses cg translationClasses structClasses |
	"This is the main Slang API to translate a program from a class.
	It 
	  - takes all the ancilliary classes from this one, separating structs from non structs
	  - create a code generator from them
	  - run type inference
	  - output the translated program to the desired file"
	
	programClasses := { mainClass }.

	SlangStructType voidStructTypeCache. "Clear cache to detect new defined structs"
	cg := CCodeGenerator new.

	translationClasses := programClasses, (cg nonStructClassesForTranslationClasses: programClasses).
	structClasses := cg structClassesForTranslationClasses: programClasses.

	cg addStructClasses: structClasses.
	translationClasses do: [ :ic | cg addClass: ic.  ].

	cg inferTypes.

	cg storeCodeOnFile: aFileReference doInlining: false.
]

{ #category : #API }
DRSlangCompiler >> exportPackage: aPackage To: aFileReference [

	| mainClass |
	self createNewPackageFor: aPackage.
	self compileClasses: aPackage.
	mainClass := self mainClassIn: aPackage asSlangCompiled.
	self exportMain: mainClass to: aFileReference
]

{ #category : #'api-translation' }
DRSlangCompiler >> exportProgram: aClass To: aFileReference [

	| programClasses cg translationClasses structClasses |
	"This is the main Slang API to translate a program from a class.
	It 
	  - takes all the ancilliary classes from this one, separating structs from non structs
	  - create a code generator from them
	  - run type inference
	  - output the translated program to the desired file"
	
	programClasses := { aClass }.

	SlangStructType voidStructTypeCache. "Clear cache to detect new defined structs"
	cg := CCodeGenerator new.

	translationClasses := programClasses, (cg nonStructClassesForTranslationClasses: programClasses).
	structClasses := cg structClassesForTranslationClasses: programClasses.

	cg addStructClasses: structClasses.
	translationClasses do: [ :ic | cg addClass: ic.  ].

	cg inferTypes.

	cg storeCodeOnFile: aFileReference doInlining: false.
]

{ #category : #types }
DRSlangCompiler >> isInstanceVariableTypeDefinition: aPragma [

	| definedClass |
	definedClass := aPragma methodClass.

	^ aPragma selector = #var:type: and: [
		  definedClass hasSlotNamed: (aPragma argumentAt: 1) ]
]

{ #category : #types }
DRSlangCompiler >> isStructClass: aClass [

	^ aClass instanceVariables isNotEmpty and: [
		  self shouldCompileInstanceVariables: aClass ]
]

{ #category : #query }
DRSlangCompiler >> mainClassIn: aRPackage [

	^ aRPackage classes detect: [ :class | class includesSelector: #main ]
]

{ #category : #slang }
DRSlangCompiler >> shouldCompileInstanceVariables: aClass [
	"If has an instance variable type definition as pragma in initialize method"

	^ (aClass includesSelector: #initialize) and: [
		  | method |
		  method := aClass >> #initialize.
		  method pragmas anySatisfy: [ :pragma |
			  self isInstanceVariableTypeDefinition: pragma ] ]
]

{ #category : #builder }
DRSlangCompiler >> slangBuilderOf: aClass [

	^ (self isStructClass: aClass)
		  ifTrue: [ DRSlangStructBuilder from: aClass ]
		  ifFalse: [ DRSlangClassBuilder from: aClass ]
]
