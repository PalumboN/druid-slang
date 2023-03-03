Class {
	#name : #DRSlangBuilder,
	#superclass : #Object,
	#instVars : [
		'sourceClass',
		'compiledClass'
	],
	#category : #'Druid-Slang'
}

{ #category : #'instance creation' }
DRSlangBuilder class >> from: aClass [

	^ self new
		  sourceClass: aClass;
		  yourself
]

{ #category : #compiling }
DRSlangBuilder >> addDefinitions [

	self addStaticDefinitions.
	self addInstanceDefinitions
]

{ #category : #compiling }
DRSlangBuilder >> addInstanceDefinitions [

	sourceClass methods
		reject: [ :m | m selector = #initialize ]
		thenDo: [ :m | self installFromSource: m ]
]

{ #category : #building }
DRSlangBuilder >> buildOn: aRPackage [

	compiledClass := self createClassOn: aRPackage.
	self addDefinitions
]

{ #category : #compiling }
DRSlangBuilder >> compileMethod: sourceMethod [
	"Just copy the method by default"

	self installMethod: sourceMethod
]

{ #category : #druid }
DRSlangBuilder >> compileWithDruid: sourceMethod [

	| compilerCompiler ir compiledMethod optimisation ast typeAnnotator hardcodedSelectors |
	optimisation := DRSlangRename sourcePackage: sourceClass package.
	typeAnnotator := DRSlangTypeAnnotator new targetPackage:
		                 compiledClass package.

	compilerCompiler := DRMethodCompilerCompiler new.
	ir := compilerCompiler generateDruidIRFor: sourceMethod.

	"HACK"
	hardcodedSelectors := { #come: . #estaCansada}.
	ir instructions
		select: [ :i |
			i isMessageSend and: [ hardcodedSelectors includes: i selector ] ]
		thenDo: [ :msg | msg inline ].

	compilerCompiler optimize: ir.

	ir applyOptimisation: optimisation.

	compiledMethod := self
		                  generateMethodFromCFG: ir
		                  withSelector: sourceMethod selector
		                  numArgs:
		                  compilerCompiler irGenerator numberOfArguments.
	ast := compiledMethod ast.
	ast pragmas: {  }.
	compiledMethod pragmas do: [ :p |
		ast addPragma: (typeAnnotator applyToPragma: p in: compiledMethod) ].
	sourceMethod pragmas do: [ :p |
		ast addPragma: (typeAnnotator applyToPragma: p in: compiledMethod) ].
	^ ast generate
]

{ #category : #compiling }
DRSlangBuilder >> createClassOn: aRPackage [

	^ compiledClass := self slangSuperclass
		  subclass: sourceClass name asSlangCompiled
		  instanceVariableNames: sourceClass instanceVariablesString 
		  classVariableNames: ''
		  package: aRPackage name
]

{ #category : #druid }
DRSlangBuilder >> generateMethodFromCFG: aDRControlFlowGraph withSelector: selector numArgs: numArgs [

	"DUPLICATED METHOD "
	| bytecodeGenerator |
	DRRegisterCollapse new applyTo: aDRControlFlowGraph.
	
	bytecodeGenerator := DRBytecodeGenerator new.
	bytecodeGenerator numArgs: numArgs.
	bytecodeGenerator methodName: selector.
	bytecodeGenerator generateTargetASTFromIR: aDRControlFlowGraph methodName: selector.
	^ bytecodeGenerator targetAST
]

{ #category : #slang }
DRSlangBuilder >> installClassCode: sourceCode [

	compiledClass classSide compile: sourceCode
]

{ #category : #compiling }
DRSlangBuilder >> installClassMethod: aMethod [

	self installClassCode: aMethod sourceCode
]

{ #category : #slang }
DRSlangBuilder >> installCode: sourceCode [

	^ compiledClass compile: sourceCode
]

{ #category : #compiling }
DRSlangBuilder >> installFromSource: sourceMethod [

	| compiledMethod |
	(sourceMethod hasPragmaNamed: #druidCompilation) ifTrue: [ 
		compiledMethod := self compileWithDruid: sourceMethod.
		^ self installMethod: compiledMethod ].

	self compileMethod: sourceMethod
]

{ #category : #compiling }
DRSlangBuilder >> installMethod: aMethod [

	self installCode: aMethod sourceCode 
]

{ #category : #types }
DRSlangBuilder >> pragmaForArg: aRBVariableNode [

	| args |
	args := {
		        aRBVariableNode name.
		        #'DRSlangTypedStruct *' } 
		collect: [ :arg |
		        RBLiteralNode value: arg ].
	^ RBPragmaNode selector: #var:type: arguments: args
]

{ #category : #accessing }
DRSlangBuilder >> sourceClass [

	^ sourceClass
]

{ #category : #accessing }
DRSlangBuilder >> sourceClass: anObject [

	sourceClass := anObject
]
