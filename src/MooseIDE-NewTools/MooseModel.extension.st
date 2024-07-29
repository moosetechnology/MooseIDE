Extension { #name : #MooseModel }

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> miMetaNavigationInspectorExtension [

	<inspectorPresentationOrder: -100 title: 'Meta Navigation'>
	^ MiMetaModelNavigationBrowser on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> miMetaNavigationItems [

	^ (self metamodel classes sorted: #name ascending) collect: [
		  :fm3class |
		  fm3class name
		  -> [ :model | (model allWithType: fm3class implementingClass) ] ]
]

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> miNavigationInspectorExtension [

	<inspectorPresentationOrder: -100 title: 'Navigation'>
	^ MiModelNavigationBrowser on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> navigationItemsFromMetamodel [

	| classes |

	^ (self metamodel classes reject: [ :a | 
		            a implementingClass isTrait ])
		           collect: [ :metaClass | 
			           metaClass implementingClass inspectorToString
			           -> (self allWithSubTypesOf: metaClass implementingClass) ]
		           thenReject: [ :a | a value isEmpty ]
]
