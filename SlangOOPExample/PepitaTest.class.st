Class {
	#name : #PepitaTest,
	#superclass : #TestCase,
	#instVars : [
		'pepita'
	],
	#category : #SlangOOPExample
}

{ #category : #running }
PepitaTest >> setUp [
	super setUp.

	pepita := Pepita new
]

{ #category : #tests }
PepitaTest >> testPepitaEmpiezaCansada [

	self deny: pepita estaCansada 
]
