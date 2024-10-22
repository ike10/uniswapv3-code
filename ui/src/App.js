import logo from './logo.svg';
import './App.css';

import React, { useState } from 'react';
import {
  Container,
  Typography,
  TextField,
  Button,
  Grid,
  Box,
  Select,
  MenuItem,
  InputLabel,
  FormControl,
} from '@mui/material';

const tokens = ['ETH', 'USDC', 'DAI']; // Sample tokens

const App = () => {
  const [fromToken, setFromToken] = useState(tokens[0]);
  const [toToken, setToToken] = useState(tokens[1]);
  const [amount, setAmount] = useState('');

  const handleSwap = () => {
    console.log(`Swapping ${amount} ${fromToken} to ${toToken}`);
    // Logic to handle the token swap goes here
  };

  return (
    <Container maxWidth="sm" style={{ marginTop: '50px' }}>
      <Typography variant="h4" align="center" gutterBottom>
        Uniswap Clone
      </Typography>
      <Grid container spacing={2}>
        <Grid item xs={12}>
          <FormControl fullWidth>
            <InputLabel id="from-token-label">From</InputLabel>
            <Select
              labelId="from-token-label"
              value={fromToken}
              onChange={(e) => setFromToken(e.target.value)}
            >
              {tokens.map((token) => (
                <MenuItem key={token} value={token}>
                  {token}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </Grid>
        <Grid item xs={12}>
          <TextField
            fullWidth
            label={`Amount in ${fromToken}`}
            variant="outlined"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
          />
        </Grid>
        <Grid item xs={12}>
          <FormControl fullWidth>
            <InputLabel id="to-token-label">To</InputLabel>
            <Select
              labelId="to-token-label"
              value={toToken}
              onChange={(e) => setToToken(e.target.value)}
            >
              {tokens.map((token) => (
                <MenuItem key={token} value={token}>
                  {token}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </Grid>
        <Grid item xs={12}>
          <Box textAlign="center" mt={2}>
            <Button
              variant="contained"
              color="primary"
              onClick={handleSwap}
              disabled={!amount}
            >
              Swap
            </Button>
          </Box>
        </Grid>
      </Grid>
    </Container>
  );
};

export default App;
