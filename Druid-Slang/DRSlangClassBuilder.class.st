Class {
	#name : #DRSlangClassBuilder,
	#superclass : #DRSlangBuilder,
	#category : #'Druid-Slang'
}

{ #category : #compiling }
DRSlangClassBuilder >> addStaticDefinitions [

	| sourceMethod |
"	self installTemplate: #declareCVarsIn:."
	sourceMethod := sourceClass classSide >> #ancilliaryClasses.
	self flag: #SuperHack.
	self installClassCode:
		sourceMethod sourceCode , ' collect: [ :c | c asSlangCompiled ]'
]

{ #category : #compiling }
DRSlangClassBuilder >> installCode: sourceCode [

	| ast aMethod |
	aMethod := super installCode: sourceCode.
	ast := (compiledClass >> aMethod) ast copy.
	"Copy-pasted"
	ast arguments do: [ :arg | ast addPragma: (self pragmaForArg: arg) ].

	super installCode: ast formattedCode
]

{ #category : #slang }
DRSlangClassBuilder >> slangSuperclass [

	^ SlangClass 
]
