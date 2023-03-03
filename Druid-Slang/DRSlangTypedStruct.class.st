Class {
	#name : #DRSlangTypedStruct,
	#superclass : #SlangStructType,
	#instVars : [
		'type'
	],
	#category : #'Druid-Slang'
}

{ #category : #converting }
DRSlangTypedStruct class >> asSlangCompiled [

	^ self
]

{ #category : #translation }
DRSlangTypedStruct class >> declareCVarsIn: aCCodeGenerator [

	aCCodeGenerator addHeaderFile: '<stdio.h>'.
	aCCodeGenerator addHeaderFile: '<stdlib.h>'
]

{ #category : #translation }
DRSlangTypedStruct class >> instVarMap [ 
	^ { ([#type] -> [#int]). }
]

{ #category : #enumerating }
DRSlangTypedStruct class >> instVarNamesAndTypesForTranslationDo: aBinaryBlock [

	self filteredInstVarNames do: [ :ivn |
		aBinaryBlock
			value: ivn
			value:
			(ivn
				 caseOf: self instVarMap
				 otherwise: [ self halt ]) ]
]

{ #category : #accessing }
DRSlangTypedStruct >> type [

	^ type
]

{ #category : #accessing }
DRSlangTypedStruct >> type: anObject [

	type := anObject
]
