Extension { #name : 'RSLayout' }

{ #category : '*MooseIDE-Visualization' }
RSLayout class >> layoutDescription [

	^ self comment
		ifNil: [ self layoutName ]
		ifNotNil: [ :classComment | classComment lines first ]
]

{ #category : '*MooseIDE-Visualization' }
RSLayout class >> layoutName [
	"remove 'RS' prefix and 'Layout' suffix"

	^ self name copyFrom: 3 to: (self name size - 6)
]
