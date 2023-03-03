Extension { #name : #Behavior }

{ #category : #'*Druid-Slang' }
Behavior >> indexInPackage [

	^ (self package classes sorted: #name ascending) indexOf: self
]
