Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowse [
	^ (GtCoder forMethod: self) 
			openInPager
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowseFrom: anElement [
	^ ((GtCoder forMethod: self) 
			openInPagerFrom: anElement)
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtDisplayOn: aStream [
	aStream print: self methodClass; nextPutAll: '>>'; store: self selector.
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtLocalVersionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Local versions';
		priority: 20;
		items: [ SourceFiles
				changeRecordsFrom: self sourcePointer
				className: self methodClass name
				isMeta: self methodClass isMeta ];
		column: 'Timestamp'
			text: #timeStamp
			width: 200;
		column: 'Change' translated
			icon: [ :eachItem | 
				BrExpander new
					vFitContent;
					hMatchParent;
					collapse;
					margin: (BlInsets all: 10);
					aptitude: GtCoderExpanderAptitude new;
					header: [ BrLabel new text: eachItem gtDisplayString ];
					content: [ | container |
						container := BrFrame new
								vExact: 400;
								hMatchParent;
								aptitude: BrGlamorousWithVerticalResizerAptitude;
								addChild: (eachItem gtSourceFor: GtPhlowEmptyView new) asElement matchParent ] ]
			weight: 1
]
