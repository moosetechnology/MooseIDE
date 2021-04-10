Extension { #name : #MiResultTreePresenter }

{ #category : #'*Midas-FamixQueries-Tests' }
MiResultTreePresenter >> items [
	^ self roots flatCollect: [ :root | self childrenOf: root ]
]
