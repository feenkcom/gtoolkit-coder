Extension { #name : #BrGlamorousTheme }

{ #category : #'*GToolkit-Coder-UI' }
BrGlamorousTheme >> diffElement [
	^ self
		subThemeAt: #gtDiffElementTheme
		ifAbsentPut: [ self newDiffElementTheme ]
]

{ #category : #'*GToolkit-Coder-UI' }
BrGlamorousTheme >> diffElement: aDiffElementTheme [
	self subThemeAt: #gtDiffElementTheme put: aDiffElementTheme
]

{ #category : #'*GToolkit-Coder-UI' }
BrGlamorousTheme >> newDiffElementTheme [
	^ GtDiffElementTheme theme: self
]
