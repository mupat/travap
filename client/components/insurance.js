import React from 'react';

class Insurance extends React.Component {
  constructor(props) {
    super(props);
  };

  render() {
    return (
      <div>
        <label htmlFor='insurances'>Insurances</label>
        <select name='insurances' onChange={this.props.selectInsurance}>
          {this.props.insurances.map(insurance =>
            <option key={insurance.id} value={insurance.id}>{insurance.name}</option>
          )}
        </select>
      </div>
    )
  }
}

export default Insurance;
