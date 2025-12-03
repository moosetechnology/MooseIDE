"
a BulkRewriter that adds a comment on the lines of duplicated Java String constantes (`public static final String`)

The duplicated constantes can be found with this script:
```
attributes := your_model allAttributes reject: #isStub.
statics := attributes select: [ :a |
	a isFinal and: 
	[ a isClassSide and: 
	[ a declaredType ifNil: [ false ] ifNotNil: [ :typ | typ name = 'String'] ] ] ].
constantes := statics select: [ :a | [a getFAST expression isLiteral] on: Error do: [ false ] ].
(constantes groupedBy: [ :a | a getFAST expression primitiveValue asLowercase ])
	associations select: [ :a | (a value size >= 2) and: [ a key size > 2 ] ]```
"
Class {
	#name : 'MiBulkEndLineCommentRewriter',
	#superclass : 'MiBulkAbstractRewriter',
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'actions' }
MiBulkEndLineCommentRewriter >> afterEol: c at: i [
	"Nothing to do after EOL
	Typically, only one of #beforeEol:at: , #afterEol:at: should be defined"

]

{ #category : 'actions' }
MiBulkEndLineCommentRewriter >> intervalEnd: c [
	"override because #nextLineDo: is different
	 see comment in super-class"

	self insideInterval: c.
	self nextLineDo: [
		stream
			<< ' // same constant as: '.
		interval data value do: [ :entity | stream << entity mooseName ] separatedBy: [ stream << ', ' ].
		self getNextInterval
	]


]
