Extension { #name : #Class }

{ #category : #'*Druid-Slang' }
Class >> asSlangCompiled [

	^ self class environment at: self name asSlangCompiled
]
