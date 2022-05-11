Extension { #name : #MooseModel }

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> miNavigationInspectorExtension [

	<inspectorPresentationOrder: -100 title: 'Navigation'>
	^ MiModelNavigationBrowser on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseModel >> mooseInterestingEntity [

	"Method used in UI. 
		- For a group with one element, returns this element
		- For a group, returns a specialized group
		- For a model, returns the entity storage optimized for runtime."

	self flag:
		'The entity storage should not be changed here, but in the loader or somewhere else'.
	self entityStorage forRuntime.
	^ self
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
