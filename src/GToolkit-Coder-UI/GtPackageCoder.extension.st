Extension { #name : #GtPackageCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtPackageCoder >> asCardElement [
	^ GtPackageCardElement new coder: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtPackageCoder >> asElement [
	^ GtPackageCoderElement new packageCoder: self
]
