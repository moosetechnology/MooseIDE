Extension { #name : #MooseModel }

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> miMetaNavigationInspectorExtension [

	<inspectorPresentationOrder: -100 title: 'Navigation'>
	^ MiMetaModelNavigationBrowser on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> miMetaNavigationItems [

	| roots |
	roots := self metamodel classes.

	^ ((roots
		    collect: [ :fm3Class |
			    fm3Class name -> (self
				     allWithType: fm3Class implementingClass
				     ofGroupClass: MooseSpecializedGroup) ]
		    thenReject: [ :association | association value isEmpty ])
		   sorted: #name ascending) , 
		((roots
		    collect: [ :fm3Class |
			    'Model ' , fm3Class name -> ((self
				      allWithType: fm3Class implementingClass
				      ofGroupClass: MooseSpecializedGroup) reject: #isStub) ]
		    thenReject: [ :association | association value isEmpty ])
		   sorted: #name ascending)
]
