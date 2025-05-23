Extension { #name : #TEntityMetaLevelDependency }

{ #category : #'*MooseIDE-Dependency' }
TEntityMetaLevelDependency >> miTreeExtension [

	<inspectorPresentationOrder: 15 title: 'Tree'>
	^ SpTreeTablePresenter new
		  addColumn: (SpCompositeTableColumn new
				   addColumn: ((SpImageTableColumn evaluated: #mooseIcon)
						    width: 20;
						    yourself);
				   addColumn: (SpStringTableColumn evaluated: #name);
				   yourself);
		  children: [ :aClass | aClass children ];
		  beMultipleSelection;
		  roots: { self };
		  beResizable
]

{ #category : #'*MooseIDE-Dependency' }
TEntityMetaLevelDependency >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM"

	"This is a hook for a temporary custom implementation to ensure we get all relevant dependencies in DSM.
It has been used before EntityTyping to get the declared type of typed entities.
It is now relevant only in the context of parametric associations, to get to the type argument.
When this dependency is resolved, this hook will be obsolete.
"

	^ self query outgoing dependencies asSet
]
