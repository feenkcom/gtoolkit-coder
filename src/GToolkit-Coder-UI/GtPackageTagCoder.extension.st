Extension { #name : #GtPackageTagCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtPackageTagCoder >> asCardElement [
	^ GtPackageTagCardElement new coder: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtPackageTagCoder >> asElement [
	^ GtPackageTagCoderElement new packageTagCoder: self
]
