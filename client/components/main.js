import React from 'react';
// import Insurance from './insurance';
// import Category from './category';

class Travap extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      places: []
    };

    // this.selectInsurance = this.selectInsurance.bind(this);
    // this.selectCategory = this.selectCategory.bind(this);

    this.props.fetch.places().then(response => {
      this.setState({ places: response });
    });
  }

  // selectInsurance(event) {
  //   const value = event.target.value;
  //   this.setState({ selectedInsurance: value });
  //   this.props.fetch.categories(value).then(response => {
  //     this.setState({ categories: JSON.parse(response).data });
  //   });
  // }
  //
  // selectCategory(event) {
  //   const value = event.target.value;
  //   this.setState({ selectedCategory: value });
  // }

  render() {
    return (
      <div>
        <h1>Travap</h1>
        <ul>
          {this.state.places.map(place =>
            <li key={ place.id }>{ place.name }</li>
          )}
        </ul>
      </div>
    );
  }
}

export default Travap
