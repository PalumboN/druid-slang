Class {
	#name : #DRSlangRename,
	#superclass : #DROptimisation,
	#instVars : [
		'sourcePackage'
	],
	#category : #'Druid-Slang'
}

{ #category : #building }
DRSlangRename class >> sourcePackage: aRPackage [

	^ self new
		  sourcePackage: aRPackage;
		  yourself
]

{ #category : #accessing }
DRSlangRename >> applyTo: cfg [

	| classConstantsToRename |
	classConstantsToRename := (cfg instructions flatCollect: #operands)
		                          select: [ :value |
			                          value isConstant and: [
				                          value value isClass and: [
					                          value value package = sourcePackage ] ] ].


	classConstantsToRename do: [ :const |
		const value: const value asSlangCompiled ].
]

{ #category : #accessing }
DRSlangRename >> sourcePackage [

	^ sourcePackage
]

{ #category : #accessing }
DRSlangRename >> sourcePackage: anObject [

	sourcePackage := anObject
]
