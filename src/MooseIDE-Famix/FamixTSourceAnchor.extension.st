Extension { #name : #FamixTSourceAnchor }

{ #category : #'*MooseIDE-Famix' }
FamixTSourceAnchor >> childInterval: aChildEntity [
	"returns nil so that anchors not dealing with it can still display in MiSourceTextBrowser"
	^nil
]
