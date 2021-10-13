Extension { #name : #RBConjunctiveCondition }

{ #category : #'*GToolkit-Coder' }
RBConjunctiveCondition >> gtChildren [
	^ { left . right }
]

{ #category : #'*GToolkit-Coder' }
RBConjunctiveCondition >> gtLeafChildren [
	^ left gtLeafChildren, right gtLeafChildren
]
