Class {
	#name : #DRSlangStructBuilder,
	#superclass : #DRSlangBuilder,
	#category : #'Druid-Slang'
}

{ #category : #adding }
DRSlangStructBuilder >> addInstanceDefinitions [

	super addInstanceDefinitions.
	self compileInit: sourceClass >> #initialize
]

{ #category : #slang }
DRSlangStructBuilder >> addStaticDefinitions [

	self installClassCode: self generateInstVarMap
]

{ #category : #building }
DRSlangStructBuilder >> compileInit: initializeMethod [
	"Now this is be used by DruidCompiler, so should have compiled name"

	| initSelector ast |
	initSelector := compiledClass name , '_' , #init.
	ast := initializeMethod ast copy.
	ast selector: initSelector.
	ast addNode: (RBAssignmentNode
			 variable: (RBVariableNode named: 'type')
			 value: sourceClass indexInPackage asLiteralNode ).

	self installCode: ast formattedCode 
]

{ #category : #compiling }
DRSlangStructBuilder >> compileMethod: sourceMethod [

	"Check if is accessor"
	(sourceClass instanceVariablesString includesSubstring:
		 (sourceMethod selector copyReplaceAll: ':' with: ''))
		ifTrue: [ self installMethod: sourceMethod ]
		ifFalse: [
			self installMethod: (sourceMethod ast
					 selector:
						 sourceMethod methodClass name , '_' , sourceMethod selector;
					 generate) ]
]

{ #category : #compiling }
DRSlangStructBuilder >> generateInstVarMap [

	| initMethod typeDefPragmas entries arrayBody |
	initMethod := sourceClass >> #initialize.
	typeDefPragmas := initMethod pragmas select: [ :pragma |
		                  pragma isTypeDefinition ].
	entries := typeDefPragmas collect: [ :pragma |
		| blocks |
		blocks := pragma arguments collect: [ :arg | '[#' , arg , ']' ].
		'(' , (' -> ' join: blocks) , ').' ].
	arrayBody := String cr join: entries.
	^ 'instVarMap 
	^ super instVarMap , { ' , arrayBody , ' }'.

]

{ #category : #slang }
DRSlangStructBuilder >> slangSuperclass [

	^ DRSlangTypedStruct
]
