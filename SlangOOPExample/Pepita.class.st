Class {
	#name : #Pepita,
	#superclass : #SlangStructType,
	#instVars : [
		'energia'
	],
	#category : #SlangOOPExample
}

{ #category : #translation }
Pepita class >> instVarMap [

	^ { ([ 'energia' ] -> [ #int ]) }
]

{ #category : #translation }
Pepita class >> instVarNamesAndTypesForTranslationDo: aBinaryBlock [

	self filteredInstVarNames do: [ :ivn |
		aBinaryBlock
			value: ivn
			value:
			(ivn
				 caseOf: self instVarMap
				 otherwise: [ self halt ]) ]
]

{ #category : #initialization }
Pepita >> come: cantidad [

	energia := energia + cantidad
]

{ #category : #accessing }
Pepita >> energia [

	^ energia
]

{ #category : #initialization }
Pepita >> estaCansada [

	^ energia < 10
]

{ #category : #initialization }
Pepita >> initialize [

	<var: #energia type: #int>
	energia := 100
]
