Class {
	#name : #Pepona,
	#superclass : #SlangStructType,
	#instVars : [
		'kms'
	],
	#category : #SlangOOPExample
}

{ #category : #accessing }
Pepona >> come: cantidad [
	"No hace nada, solo importa los kilometros"

	
]

{ #category : #initialization }
Pepona >> estaCansada [

	^ kms > 50
]

{ #category : #initialization }
Pepona >> initialize [

	<var: #kms type: #int>
	kms := 0
]

{ #category : #accessing }
Pepona >> kms [

	^ kms
]
