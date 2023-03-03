Extension { #name : #Pragma }

{ #category : #'*Druid-Slang' }
Pragma >> isTypeDefinition [

	^ self selector = #var:type:
]
