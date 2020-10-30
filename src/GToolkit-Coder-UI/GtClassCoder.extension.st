Extension { #name : #GtClassCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtClassCoder >> asCardElement [
	^ GtClassCardElement new coder: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtClassCoder >> asElement [
	| coderElement |
	coderElement := GtBehaviorCoderElement new classCoder: self.
	^ coderElement
]
