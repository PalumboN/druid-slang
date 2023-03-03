Class {
	#name : #DRSlangTypeAnnotator,
	#superclass : #DROptimisation,
	#instVars : [
		'targetPackage'
	],
	#category : #'Druid-Slang'
}

{ #category : #accessing }
DRSlangTypeAnnotator >> applyTo: cfg [


	cfg instructions select: [ :i | i isMessageSend ]
]

{ #category : #optimisations }
DRSlangTypeAnnotator >> applyToPragma: aPragma in: compiledMethod [

	| typeSting class varNode assignmentNode |
	(aPragma isTypeDefinition and: [ (aPragma argumentAt: 1) isNil ])
		ifTrue: [
			typeSting := aPragma argumentAt: 2.
			class := (typeSting trimRight: [ :each | each = $* ]) asClass.

			varNode := compiledMethod ast allVariables detect: [ :var |
				           var variable value = class ].
			assignmentNode := varNode allParents reversed detect: [ :node |
				                  node isAssignment ].

			^ RBPragmaNode selector: aPragma selector arguments: ({
					   assignmentNode variable name.
					   typeSting } collect: [ :arg | RBLiteralNode value: arg ]) ].



	^ RBPragmaNode
		  selector: aPragma selector
		  arguments:
		  (aPragma arguments collect: [ :arg | RBLiteralNode value: arg ])
]

{ #category : #accessing }
DRSlangTypeAnnotator >> targetPackage [

	^ targetPackage
]

{ #category : #accessing }
DRSlangTypeAnnotator >> targetPackage: anObject [

	targetPackage := anObject
]
