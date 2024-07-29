Extension { #name : #MooseModel }

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> miMetaNavigationInspectorExtension [

	<inspectorPresentationOrder: -100 title: 'Meta Navigation'>
	^ MiMetaModelNavigationBrowser on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> miMetaNavigationItems [

	^ (self metamodel packages sorted: #name ascending) collect: [
		  :fm3package | fm3package name -> fm3package ]
]

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> miNavigationInspectorExtension [

	<inspectorPresentationOrder: -100 title: 'Navigation'>
	^ MiModelNavigationBrowser on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> navigationItemsFromMetamodel [

	^ (self metamodel classes reject: [ :a | a implementingClass isTrait ])
		  collect: [ :metaClass |
			  metaClass implementingClass inspectorToString
			  -> (self allWithType: metaClass implementingClass) ]
		  thenReject: [ :a | a value isEmpty ]
]
