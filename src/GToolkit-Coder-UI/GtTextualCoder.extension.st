Extension { #name : #GtTextualCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtTextualCoder >> wantsHeader [
	^ self attributeNamed: #withHeader ifAbsent: [ true ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtTextualCoder >> withHeader [
	self attributeNamed: #withHeader put: true
]

{ #category : #'*GToolkit-Coder-UI' }
GtTextualCoder >> withoutHeader [
	self attributeNamed: #withHeader put: false
]
