Extension { #name : #GtSourceCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSourceCoder >> createLabel: aString description: description [
	^ aString asRopedText glamorousRegularFont
		, ((' ' , description) asRopedText
				glamorousCodeFont;
				foreground: Color gray;
				glamorousCodeTinySize)
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtSourceCoder >> extractableNodesAt: anIndex [
	"Return a collection of extractable nodes that intersect a given interval"
	<return: #Collection of: #GtPharoProgramNode>

	^ self
		nodeAt: anIndex
		ifFound: [ :aNode |
			aNode isSequence
				ifTrue: [ aNode statements select: [ :eachNode | eachNode intersectsInterval: (anIndex to: anIndex) ] ]
				ifFalse: [ { aNode isMessage ifTrue: [ aNode parent ] ifFalse: [ aNode ] } ] ]
		ifNone: [ #() ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtSourceCoder >> extractableNodesFrom: aCoderViewModel [
	| allSelections allCursors |

	allSelections := aCoderViewModel selection allSelections.
	allCursors := aCoderViewModel cursors allCursors.

	^ allSelections size = 1
		ifTrue: [ self extractableNodesWithin: allSelections first interval ]
		ifFalse: [ allCursors size = 1
			ifTrue: [ self extractableNodesAt: allCursors first position ]
			ifFalse: [ #() ] ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtSourceCoder >> extractableNodesWithin: anInterval [
	"Return a collection of extractable nodes that intersect a given interval"

	<return: #Collection of: #GtPharoProgramNode>
	^ self
		nodeWithin: anInterval
		ifFound: [ :aNode | 
			aNode isSequence
				ifTrue: [ aNode statements
						select: [ :eachNode | eachNode intersectsInterval: anInterval ] ]
				ifFalse: [ {aNode} ] ]
		ifNone: [ #() ] 
]
