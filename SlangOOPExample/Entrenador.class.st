Class {
	#name : #Entrenador,
	#superclass : #SlangClass,
	#category : #SlangOOPExample
}

{ #category : #translation }
Entrenador class >> ancilliaryClasses [

	^ {
		  Pepita.
		  Pepona.
		  DRSlangTypedStruct }
]

{ #category : #initialization }
Entrenador >> alimentar: ave [

	<druidCompilation>
	ave come: 5.

	^ 1 "if not returns self. (TODO: null as default return value)"
]

{ #category : #initialization }
Entrenador >> main [

	<api> "To avoid making it static"
	<druidCompilation>
	| ave |
	ave := Pepita new.
	self alimentar: ave.
	self printf: '%d\n' _: ave estaCansada.

	^ 1
]
