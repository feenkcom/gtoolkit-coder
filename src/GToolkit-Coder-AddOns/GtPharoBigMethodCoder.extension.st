Extension { #name : #GtPharoBigMethodCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoBigMethodCoder >> asCoderViewModel [
	^ GtPharoBigMethodCoderViewModel new
		coder: self;
		yourself
]
