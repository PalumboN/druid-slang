Extension { #name : #RPackage }

{ #category : #'*Druid-Slang' }
RPackage >> asSlangCompiled [

	^ self name asSlangCompiled asPackage 
]
