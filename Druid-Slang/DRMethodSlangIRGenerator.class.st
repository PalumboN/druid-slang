Class {
	#name : #DRMethodSlangIRGenerator,
	#superclass : #DRMethodIRGenerator,
	#category : #'Druid-Slang'
}

{ #category : #initialization }
DRMethodSlangIRGenerator >> initializeSpecialCases [

	super initializeSpecialCases.
	specialCases at: #new put: #interpretNewWith:.
	specialCases removeKey: #sizeof:
]

{ #category : #interpreting }
DRMethodSlangIRGenerator >> interpretNewWith: aRBMessageNode [

	| class |
	class := self visitOperand: aRBMessageNode receiver.
	self
		addInstructionFrom: aRBMessageNode
		instructionKind: DRInstanciation
		operands: { class }
]
